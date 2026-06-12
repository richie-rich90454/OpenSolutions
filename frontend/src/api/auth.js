import api from './axios';

export const login = (email, password) =>
  api.post('/auth/login', { email, password });

export const register = (email, password, name) =>
  api.post('/auth/register', { email, password, name });

export const verifyEmail = (email, code) =>
  api.post('/auth/verify', { email, code });

export const resendVerification = (email) =>
  api.post('/auth/resend', { email });
