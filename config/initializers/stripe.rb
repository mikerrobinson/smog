Stripe.api_key = ENV["sk_test_2jvcJNCiOeeCYIKCiZfQLeQN"]
STRIPE_PUBLIC_KEY = ENV["pk_test_QWQK0FjNX2kL4MoN5nGEFTIs"]

StripeEvent.setup do
  subscribe 'customer.subscription.deleted' do |event|
    user = User.find_by_customer_id(event.data.object.customer)
    user.expire
  end
end