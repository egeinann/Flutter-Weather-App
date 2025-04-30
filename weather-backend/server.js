const express = require('express');
const fs = require('fs');
const app = express();
const PORT = 3000;

let cityData = [];

// Şehir verisini dosyadan okuma
try {
  console.log("Veri dosyasını okuma başlatılıyor...");
  const rawData = fs.readFileSync('./city.list.json', 'utf8');
  cityData = JSON.parse(rawData);
  console.log("Veri dosyası başarıyla okundu.");
} catch (error) {
  console.error('Dosya okuma hatası:', error);
  process.exit(1); // Sunucunun başlamasını engelle
}

// API'yi oluşturma
app.get('/api/cities', (req, res) => {
  const query = req.query.q?.toLowerCase() || '';
  const filteredCities = cityData
    .filter(city => city.name.toLowerCase().includes(query))
    .map(city => city.name);
  res.json([...new Set(filteredCities)]);
});

// Sunucuyu başlatma
app.listen(PORT, () => {
  console.log(`✅ Sunucu çalışıyor: http://localhost:${PORT}`);
}).on('error', (err) => {
  console.error('Sunucu hatası: ', err);
});