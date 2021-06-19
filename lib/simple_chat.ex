defmodule SimpleChat do
  use Application

  def start(_type, _args) do
    children = [
      SimpleChat.Chat,
      SimpleChat.TelegramHandler
    ]
    opts = [strategy: :one_for_one, name: SimpleChat.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
