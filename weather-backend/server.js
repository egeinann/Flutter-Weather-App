const express = require('express');
const axios = require('axios');
const cors = require('cors');

const app = express();
const PORT = 3000;

// API anahtarını burada saklayalım
const API_KEY = '743039ab6e01c2de7ad71b56d95a428d';

app.use(cors());

app.get('/weather', async (req, res) => {
  const city = req.query.city;

  if (!city) {
    return res.status(400).json({ message: 'Şehir adı gerekli' });
  }

  try {
    const response = await axios.get(
      `https://api.openweathermap.org/data/2.5/weather`,
      {
        params: {
          q: city,
          appid: API_KEY,
          units: 'metric',
          lang: 'tr',
        },
      }
    );

    // Gelen veriyi 'WeatherModel' formatında dönüştürüp gönderiyoruz
    const weatherData = {
      cityName: response.data.name,
      country: response.data.sys.country,
      temperature: response.data.main.temp,
      humidity: response.data.main.humidity,
      windSpeed: response.data.wind.speed,
      description: response.data.weather[0].description,
    };

    res.json(weatherData); // Veriyi model formatında geri döndürüyoruz
  } catch (error) {
    res.status(500).json({
      message: error.response?.data?.message || 'Hava durumu alınamadı',
    });
  }
});

app.listen(PORT, () => {
  console.log(`Sunucu çalışıyor: http://localhost:${PORT}`);
});