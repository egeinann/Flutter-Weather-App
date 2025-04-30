const express = require('express');
const fs = require('fs');
const http = require('http');
const app = express();
const PORT = 3000;

// Şehir verisini dosyadan okuma
const rawData = fs.readFileSync('./city.list.json', 'utf8');
const cityData = JSON.parse(rawData);

// API'yi oluşturma
app.get('/api/cities', (req, res) => {
  const query = req.query.q?.toLowerCase() || '';
  const filteredCities = cityData
    .filter(city => city.name.toLowerCase().includes(query))
    .map(city => city.name);
  res.json([...new Set(filteredCities)]);
});

// HTTP sunucusunu oluşturma ve zaman aşımı ayarlama
const server = http.createServer(app);

// Zaman aşımı süresi ayarlama (5 dakika)
server.setTimeout(1000 * 60 * 5, () => {
  console.log('Sunucu 5 dakika boyunca işlem yapılmadığı için zaman aşımına uğradı.');
});

// Sunucuyu başlatma
server.listen(PORT, () => {
  console.log(`✅ Sunucu çalışıyor: http://localhost:${PORT}`);
}).on('error', (err) => {
  console.error('Sunucu hatası: ', err);
});