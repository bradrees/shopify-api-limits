
require './spec/boot'

describe "Throttle" do
  it "Can fetch local limits" do
    count = ShopifyAPI.credit_used
    limit = ShopifyAPI.credit_limit
    
    expect(count < limit).to be true
    expect(count > 0).to be true
    expect(ShopifyAPI.credit_maxed?).to be false
    expect(ShopifyAPI.credit_left > 0).to be true
  end
  
  it "Can execute up to local max" do
    until ShopifyAPI.credit_maxed?
      ShopifyAPI::Shop.current
      puts "avail: #{ShopifyAPI.credit_left}, maxed: #{ShopifyAPI.credit_maxed?}"
    end
    expect(ShopifyAPI.credit_maxed?).to be true
    expect(ShopifyAPI.credit_left == 0).to be true

    puts "Response:"
    ShopifyAPI.response.each{|header,value| puts "#{header}: #{value}" }

    puts "Retry after: #{ShopifyAPI.retry_after}"
    expect(ShopifyAPI.retry_after > 0).to be true
  end
    
end
