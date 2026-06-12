import api from './axios';

export const getChannels = () =>
  api.get('/channels');

export const getChannel = (id) =>
  api.get(`/channels/${id}`);

export const createChannelThread = (channelId, data) =>
  api.post(`/channels/${channelId}/threads`, data);

export const getChannelPosts = (channelId, threadId) =>
  api.get(`/channels/${channelId}/threads/${threadId}/posts`);

export const createChannelPost = (channelId, threadId, content) =>
  api.post(`/channels/${channelId}/threads/${threadId}/posts`, { content });
