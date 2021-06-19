defmodule SimpleChat.TelegramHandler do
  use GenServer

  def init state \\ nil do
    case Nadia.get_me do
      {:ok, _} ->
        spawn(updater())
        {:ok, state}
      _ -> {:error, "Не удалось получить себя"}
    end
  end

  def process_update %{message: %{from: %{id: id}, text: text}} do
    case text do
      "/start" ->
        msg = SimpleChat.Chat.new_user(id)
        Nadia.send_message id, "welcome to the club: #{msg}"
      "/stop" ->
        msg = SimpleChat.Chat.remove_user(id)
        Nadia.send_message id, "bye: #{msg}"
      _ -> nil
    end
  end

  def updater offset \\ 1 do
    {:ok, updates} = Nadia.get_updates(offset: offset)
    Enum.each updates, &process_update(&1)
    %{update_id: new_offset} =
      Enum.max_by updates,
                  (fn %{update_id: id} -> id end),
                  (fn -> %{update_id: offset} end)
    updater (new_offset + 1)
  end

  def start_link(init, options \\ []), do:
    GenServer.start_link(__MODULE__, init, options)

end
