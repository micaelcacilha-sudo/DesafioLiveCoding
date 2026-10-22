const express = require('express');
const app = express();


app.use(express.json());


const validaCnh = require('./middlewares/validaCnh');


let motoristas = [];
let proximoId = 1;


app.get('/api/v1/health', (req, res) => {
    return res.status(200).json({
        status: 'OK',
        uptime: `${Math.floor(process.uptime())}s`,
        memoryUsage: process.memoryUsage()
    });
});


app.post('/api/v1/motoristas', validaCnh, (req, res) => {
    const { nome, cnh } = req.body;
    const novoMotorista = { id: proximoId++, nome, cnh };
    motoristas.push(novoMotorista);
    return res.status(201).json(novoMotorista);
});

app.get('/api/v1/motoristas', (req, res) => {
    return res.status(200).json(motoristas);
});

app.get('/api/v1/motoristas/:id', (req, res) => {
    const id = parseInt(req.params.id);
    const motorista = motoristas.find(m => m.id === id);
    if (!motorista) {
        return res.status(404).json({ erro: 'Motorista não encontrado.' });
    }
    return res.status(200).json(motorista);
});

app.put('/api/v1/motoristas/:id', validaCnh, (req, res) => {
    const id = parseInt(req.params.id);
    const index = motoristas.findIndex(m => m.id === id);
    if (index === -1) {
        return res.status(404).json({ erro: 'Motorista não encontrado.' });
    }
    motoristas[index] = { id, ...req.body };
    return res.status(200).json(motoristas[index]);
});

app.delete('/api/v1/motoristas/:id', (req, res) => {
    const id = parseInt(req.params.id);
    const index = motoristas.findIndex(m => m.id === id);
    if (index === -1) {
        return res.status(404).json({ erro: 'Motorista não encontrado.' });
    }
    motoristas.splice(index, 1);
    return res.status(204).send();
});


app.use((req, res) => {
    return res.status(404).json({
        erro: 'Endpoint nao encontrado no servidor Binario Tech.'
    });
});



const PORT = process.env.PORT || 3000;

app.listen(PORT, () => {
    console.log(`Servidor rodando com sucesso na porta ${PORT}`);
});
