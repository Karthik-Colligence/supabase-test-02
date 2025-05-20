import { supabase } from '../../lib/supabase';

const switchOrganization = async (orgId: string) => {
  const { data, error } = await supabase
    .from('organizations')
    .select('*')
    .eq('id', orgId)
    .single();
  if (error) throw error;
  // Update Zustand store with new organization
};
