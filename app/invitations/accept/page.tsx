import { supabase } from '../../../lib/supabase';

const acceptInvitation = async (email: string, token: string) => {
  const { error } = await supabase.auth.signInWithOtp({ email, options: { data: { invitation_token: token } } });
  if (error) throw error;
  return 'Magic link sent';
};