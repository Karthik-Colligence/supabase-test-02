import { supabase } from '../../lib/supabase';

const uploadAvatar = async (file: File, userId: string) => {
  const { data, error } = await supabase.storage
    .from('avatars')
    .upload(`${userId}/${file.name}`, file);
  if (error) throw error;
  return data.path;
};
