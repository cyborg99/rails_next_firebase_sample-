# frozen_string_literal: true

Rails.application.config.middleware.insert_before Rack::Head, ActionDispatch::Cookies
Rails.application.config.middleware.insert_after ActionDispatch::Cookies, ActionDispatch::Session::RedisStore,
  servers: ['redis://redis:6379/0'],
  expire_after: 1.year,
  key: "_app_session"
