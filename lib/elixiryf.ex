defmodule Elixiryf do
  alias Elixiryf.Constants, as: Constants
  alias Elixiryf.Ticker, as: Ticker
  @moduledoc """
  Documentation for `Elixiryf`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Elixiryf.hello()
      :world

  """
  def get_ticker_current_value(ticker_name) do
    HTTPoison.start()

    headers = [
      {"User-Agent", Constants.user_agent()},
    ]

    url = "#{Constants.base_url()}#{ticker_name}"

    case HTTPoison.get(url, headers, follow_redirect: true) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        IO.puts("Fetched data successfully!")
        value = body
                |> Floki.parse_document!()
                |> Floki.find("fin-streamer[data-field='regularMarketPrice'][data-symbol='#{ticker_name}']")
                |> Floki.text()
                |> String.to_float()
        
        ticker = %Ticker{name: ticker_name, value: value}
        inspect(ticker)

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        IO.puts("Failed to fetch data. Status code: #{status_code}")
        :error

      {:error, %HTTPoison.Error{reason: reason}} ->
        IO.puts("Error occurred: #{reason}")
        :error
    end
  end
end
