# frozen_string_literal: true

resources :applications, param: :token do
  resources :chats, only: [:index, :create, :show], param: :number do
    resources :messages, only: [:index, :create] do
      collection do
        get :search
      end
    end
  end
end
