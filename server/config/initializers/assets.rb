# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'

Cloudinary.config do |config|
  config.cloud_name = 'laucity'
  config.api_key = '763363812828244'
  config.api_secret = '4xldqQ3oNVHpNEh0lMPltu4CKW0'
  config.cdn_subdomain = false
end

# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
