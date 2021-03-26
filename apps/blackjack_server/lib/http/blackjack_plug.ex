defmodule BlackjackServer.Plug do
  use Plug.Router

  @valid_secret String.duplicate("abcdef0123456789", 8)

  plug Plug.Session, store: :cookie, key: "_plugger", secret: @valid_secret, signing_salt: "REEEE", encryption_salt: "REEE"

  plug Plug.Static, from: :blackjack_server, at: "/react/"
  plug :match
  plug :dispatch
  plug :put_secret_key_base

  def put_secret_key_base(conn, _) do
    put_in conn.secret_key_base, "-- LONG STRING WITH AT LEAST 64 BYTES --"
  end

  get "/connect" do
    {:ok, pid} = Blackjack.Dealer.connect()
    sid = "#{inspect make_ref()}"
    BlackjackServer.PIDAgent.put(sid, pid)
    response = Blackjack.Dealer.cards(pid)
    send_resp(put_resp_cookie(conn, "sid", sid), 200, elem(JSON.encode(response),1))
  end

  get "/hit" do
    sid = fetch_cookies(conn).req_cookies["sid"]
    pid = BlackjackServer.PIDAgent.get(sid)
    response = Blackjack.Dealer.hit(pid)
    send_resp(conn, 200, elem(JSON.encode(response),1))
  end

  get "/cards" do
    sid = fetch_cookies(conn).req_cookies["sid"]
    pid = BlackjackServer.PIDAgent.get(sid)
    response = Blackjack.Dealer.cards(pid)
    send_resp(conn, 200, elem(JSON.encode(response),1))
  end

  get "/reset" do
    sid = fetch_cookies(conn).req_cookies["sid"]
    pid = BlackjackServer.PIDAgent.get(sid)
    response = Blackjack.Dealer.reset(pid)
    send_resp(conn, 200, elem(JSON.encode(response),1))
  end

  get "/stats" do
    sid = fetch_cookies(conn).req_cookies["sid"]
    pid = BlackjackServer.PIDAgent.get(sid)
    response = Blackjack.Dealer.stats(pid)
    send_resp(conn, 200, elem(JSON.encode(response),1))
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
