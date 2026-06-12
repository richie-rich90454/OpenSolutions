import { useQuery, useMutation, useQueryClient } from '@tanstack/react-query';
import { getResourcePosts, createResourcePost } from '../api/threads';

export function useResourcePosts(resourceId) {
  return useQuery({
    queryKey: ['resourcePosts', resourceId],
    queryFn: () => getResourcePosts(resourceId).then((r) => r.data),
    enabled: !!resourceId,
  });
}

export function useCreateResourcePost(resourceId) {
  const queryClient = useQueryClient();
  return useMutation({
    mutationFn: (content) => createResourcePost(resourceId, content),
    onSuccess: () => {
      queryClient.invalidateQueries({ queryKey: ['resourcePosts', resourceId] });
    },
  });
}
