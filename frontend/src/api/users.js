import api from './axios';

export const getMyProfile = () =>
  api.get('/users/me');

export const getUserProfile = (id) =>
  api.get(`/users/${id}`);

export const updateProfile = (data) =>
  api.put('/users/me', data);

export const updateSubjects = (subjects) =>
  api.put('/users/me/subjects', { subjects });

export const addSocial = (data) =>
  api.post('/users/me/socials', data);

export const removeSocial = (socialId) =>
  api.delete(`/users/me/socials/${socialId}`);
