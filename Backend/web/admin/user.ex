defmodule Chatter.ExAdmin.User do
  use ExAdmin.Register

  register_resource Chatter.User do
    index do
      selectable_column

      column :id
      column :name
      column :login

      actions
    end

    form user do
      inputs do
        input user, :name
        input user, :login
        input user, :password
      end
    end
  end
end
