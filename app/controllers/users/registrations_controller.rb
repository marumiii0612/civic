# app/controllers/users/registrations_controller.rb
class Users::RegistrationsController < Devise::RegistrationsController
  # Devise の「ログインしてたらサインアップ不可」を解除
  skip_before_action :require_no_authentication, only: [:new, :create]

  # ログイン中に作成できるのは管理者だけ（要件に合わせて変更可）
  before_action :ensure_admin!, only: [:new, :create], if: -> { user_signed_in? }

  def create
    build_resource(sign_up_params)

    if resource.save
      if current_user&.admin?
        # 管理者が作成 → 管理者のセッションは維持（切り替えない）
        set_flash_message! :notice, :created
        redirect_to root_path
      else
        # 未ログインの通常サインアップ → 自動ログイン
        if resource.active_for_authentication?
          set_flash_message! :notice, :signed_up
          sign_up(resource_name, resource)
          respond_with resource, location: after_sign_up_path_for(resource)
        else
          set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
          expire_data_after_sign_in!
          respond_with resource, location: after_inactive_sign_up_path_for(resource)
        end
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource, status: :unprocessable_entity
    end
  end

  protected

  # 管理者が作成する時はセッション切替を抑止
  def sign_up(resource_name, resource)
    super unless current_user&.admin?
  end

  def ensure_admin!
    redirect_to root_path, alert: '権限がありません。' unless current_user.admin?
  end
end
