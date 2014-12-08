FactoryGirl.define do

  factory :notification, aliases: [:notification_protocol_create] do
    sparc_id 1
    kind 'Protocol'
    action 'create'
    callback_url 'http://localhost:5000/protocols/1.json'

    trait :protocol do
      kind 'Protocol'
      callback_url 'http://localhost:5000/protocols/1.json'
    end

    trait :service do
      kind 'Service'
      callback_url 'http://localhost:5000/services/1.json'
    end

    trait :create do
      action 'create'
    end

    trait :update do
      action 'update'
    end

    factory :notification_service_create, traits: [:service, :create]
    factory :notification_service_update, traits: [:service, :update]
  end
end
