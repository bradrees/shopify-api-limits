require 'bundler'
Bundler.require(:default, :development)

require 'yaml'

# Load shopify config
config = ENV.fetch('SHOPIFY_API_YAML', nil) ? YAML.load(ENV.fetch('SHOPIFY_API_YAML')) : YAML.load_file(File.join(File.dirname(__FILE__), "shopify_api.yml"))

begin
  ShopifyAPI::ApiVersion.version_lookup_mode = :raise_on_unknown
  ShopifyAPI::ApiVersion.fetch_known_versions
  ShopifyAPI::Meta.admin_versions.each do |v|
    ShopifyAPI::Base.api_version = v.handle
  end
rescue StandardError => e
  puts e
end

ShopifyAPI::Base.site = config["site"]
