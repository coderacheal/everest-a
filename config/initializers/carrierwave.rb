# config/initializers/carrierwave.rb
CarrierWave.configure do |config|
    config.storage = :file # Use the local file system for storage
  end
# config/initializers/carrierwave.rb
CarrierWave.configure do |config|
    config.storage = :fog
    config.fog_credentials = {
      provider: 'AWS',
      aws_access_key_id: 'AKIAQKNYM2UTJDFQXUJC',
      aws_secret_access_key: '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',
      region: 'Europe (Frankfurt) eu-central-1' 
    }
    config.fog_directory = 'everestprofile'
  end
  