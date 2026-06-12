import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import {
  getMyProfile,
  getUserProfile,
  updateProfile,
  updateSubjects,
  addSocial,
  removeSocial,
} from '../api/users';

export function useMyProfile() {
  return useQuery({
    queryKey: ['profile', 'me'],
    queryFn: () => getMyProfile().then((r) => r.data),
  });
}

export function useUserProfile(id) {
  return useQuery({
    queryKey: ['profile', id],
    queryFn: () => getUserProfile(id).then((r) => r.data),
    enabled: !!id,
  });
}

export function useUpdateProfile() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data) => updateProfile(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['profile', 'me'] });
    },
  });
}

export function useUpdateSubjects() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (subjects) => updateSubjects(subjects),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['profile', 'me'] });
    },
  });
}

export function useAddSocial() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (data) => addSocial(data),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['profile', 'me'] });
    },
  });
}

export function useRemoveSocial() {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (socialId) => removeSocial(socialId),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['profile', 'me'] });
    },
  });
}
