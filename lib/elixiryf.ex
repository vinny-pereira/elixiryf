defmodule Elixiryf do
  use Crawly.Spider
  alias Elixiryf.Constants, as: Constants
  @moduledoc """
  Documentation for `Elixiryf`.
  """

  @doc """
  Hello world.

  ## Examples

      iex> Elixiryf.hello()
      :world

  """
  @impl Crawly.Spider
  def base_url(), do: Constants.base_url()

  def get_ticket_current_price(ticket) do
    url = "#{base_url()}#{ticket}" 
    Crawly.Requests.request(url)
  end

  @impl Crawly.Spider
  def parse_item(response) do
    price =
      response.body
      |> Floki.parse_document!()
      |> Floki.find("fin-streamer[data-field='regularMarketPrice']")
      |> Floki.text()

    %{
      ticket: response.request_url |> String.split("/") |> List.last(),
      price: price
    }
  end
end
