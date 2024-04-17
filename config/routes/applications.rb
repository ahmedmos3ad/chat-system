# frozen_string_literal: true

resources :applications, only: [:create, :index] do
  collection do
    get ":token", action: :show
    put ":token", action: :update
    delete ":token", action: :destroy
  end
end
