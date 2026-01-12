-- Add admin_name column to payment_methods table
DO $$
BEGIN
  IF NOT EXISTS (
    SELECT 1 FROM information_schema.columns
    WHERE table_name = 'payment_methods' AND column_name = 'admin_name'
  ) THEN
    ALTER TABLE payment_methods ADD COLUMN admin_name text;
    -- Set existing payment methods to "Old"
    UPDATE payment_methods SET admin_name = 'Old' WHERE admin_name IS NULL;
  END IF;
END $$;

-- Create admin_payment_groups table to store admin names and their toggle states
CREATE TABLE IF NOT EXISTS admin_payment_groups (
  id uuid DEFAULT gen_random_uuid() PRIMARY KEY,
  admin_name text NOT NULL UNIQUE,
  is_active boolean NOT NULL DEFAULT false,
  created_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at timestamp with time zone DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Insert "Old" admin group if it doesn't exist
INSERT INTO admin_payment_groups (admin_name, is_active)
VALUES ('Old', false)
ON CONFLICT (admin_name) DO NOTHING;

-- Create index for faster lookups
CREATE INDEX IF NOT EXISTS idx_payment_methods_admin_name ON payment_methods(admin_name);
CREATE INDEX IF NOT EXISTS idx_admin_payment_groups_admin_name ON admin_payment_groups(admin_name);
