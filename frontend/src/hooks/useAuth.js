import { useMutation } from '@tanstack/react-query';
import { useNavigate } from 'react-router-dom';
import { login, register, verifyEmail } from '../api/auth';
import useAuthStore from '../store/authStore';

export function useLogin() {
  const setAuth = useAuthStore((s) => s.setAuth);
  const navigate = useNavigate();

  return useMutation({
    mutationFn: ({ email, password }) => login(email, password),
    onSuccess: (response) => {
      const { token, user } = response.data;
      setAuth(token, user);
      navigate('/');
    },
  });
}

export function useRegister() {
  const navigate = useNavigate();

  return useMutation({
    mutationFn: ({ email, password, name }) => register(email, password, name),
    onSuccess: (_, variables) => {
      navigate(`/verify?email=${encodeURIComponent(variables.email)}`);
    },
  });
}

export function useVerifyEmail() {
  const navigate = useNavigate();

  return useMutation({
    mutationFn: ({ email, code }) => verifyEmail(email, code),
    onSuccess: () => {
      navigate('/login');
    },
  });
}
