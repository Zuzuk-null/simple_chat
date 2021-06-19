defmodule SimpleChat.Chat do
  use Supervisor

  def start_link(_opts) do
    Supervisor.start_link(__MODULE__, :ok, name: __MODULE__)
  end

  def new_user(uid) do
    Supervisor.start_child(__MODULE__, {SimpleChat.User, fn -> uid end})
  end

  def remove_user(uid) do
    Supervisor.delete_child(__MODULE__, {SimpleChat.User, fn -> uid end})
  end

  def init(:ok) do
    children = [
      {DynamicSupervisor, strategy: :one_for_one, name: MyApp.DynamicSupervisor}
    ]
    Supervisor.init(children, strategy: :simple_one_for_one)
  end

end
