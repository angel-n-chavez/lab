import axios from 'axios';

// create an instance of axios with the base URL
const api = axios.create({
  baseURL: "http://localhost:8000"
});

// import axios instance
export default api;
