-- Add notification_volume site setting
INSERT INTO site_settings (id, value, type, description, updated_at)
VALUES ('notification_volume', '0.5', 'number', 'Notification volume for new orders (0.0 to 1.0)', now())
ON CONFLICT (id) DO UPDATE SET
  value = EXCLUDED.value,
  description = EXCLUDED.description,
  updated_at = EXCLUDED.updated_at;
