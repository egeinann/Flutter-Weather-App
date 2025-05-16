const express = require('express');
const axios = require('axios');
const cors = require('cors');
const fs = require('fs');
const path = require('path');

const app = express();
const PORT = 3000;

const API_KEY = '743039ab6e01c2de7ad71b56d95a428d';

// CORS ayarları
app.use(cors());

// Assets klasörünü public hale getir
app.use('/assets', express.static(path.join(__dirname, 'assets')));

// Şehirler listesi
app.get('/cities', (req, res) => {
  const cityListPath = path.join(__dirname, 'city.list.json');
  fs.readFile(cityListPath, 'utf8', (err, data) => {
    if (err) {
      console.error(err);
      return res.status(500).json({ message: 'Şehir listesi alınamadı' });
    }

    try {
      const cities = [...new Set(JSON.parse(data).map(city => city.name))];
      res.json(cities);
    } catch (parseError) {
      console.error(parseError);
      res.status(500).json({ message: 'Şehir listesi verileri işlenemedi' });
    }
  });
});

// Ortak isDay hesaplama fonksiyonu
function getIsDay(sunrise, sunset) {
  const currentTime = Math.floor(Date.now() / 1000); // Şu anki zaman (saniye cinsinden)
  return currentTime >= sunrise && currentTime < sunset;
}

// Şehir ismine göre hava durumu
app.get('/weather', async (req, res) => {
  const city = req.query.city;
  if (!city) {
    return res.status(400).json({ message: 'Şehir adı gerekli' });
  }

  try {
    const response = await axios.get(`https://api.openweathermap.org/data/2.5/weather`, {
      params: {
        q: city,
        appid: API_KEY,
        units: 'metric',
        lang: 'en',
      },
    });

    const { sunrise, sunset } = response.data.sys;
    const isDay = getIsDay(sunrise, sunset);

    const weatherData = {
    cityName: response.data.name,
    country: response.data.sys.country,
    temperature: Math.round(response.data.main.temp),
    humidity: response.data.main.humidity,
    windSpeed: response.data.wind.speed,
    description: response.data.weather[0].description,
    isDay,
    tempMin: Math.round(response.data.main.temp_min),
    tempMax: Math.round(response.data.main.temp_max),
  };

    res.json(weatherData);
  } catch (error) {
    console.error(error);
    res.status(500).json({
      message: error.response?.data?.message || 'Backend error',
    });
  }
});

// Sunucuyu başlat
app.listen(PORT, () => {
  console.log(`Sunucu çalışıyor: http://localhost:${PORT}`);
});
