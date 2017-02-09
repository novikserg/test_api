Rails.application.routes.draw do
  mount_devise_token_auth_for "Company", at: "api/v1/auth"

  namespace :api do
    namespace :v1 do
      devise_scope :company do
        resources :transactions, only: [:index, :create, :show, :update, :destroy] do
          resources :bank_guarantees, only: [:index, :create, :show, :update, :destroy]
        end
      end
    end
  end
end
