# Elixir Meetup

## Plug'n'play

### In this tutorial we will create our own little framework called phonix

#### 1 create phonix (with an initial supervisor)
``` bash
bash\> mix new --sup phonix
```

#### 2 install cowboy and plug
Add to mix.ex
```elixir
defp deps do
  [
    {:cowboy, "~> 1.1"},  
    {:plug, "~> 1.3"}
  ]
end
```

```bash
bash\> mix deps.get
bash\> mix deps.compile
```

#### 3 smallest plug-module
We create our own small plug, because when we would like to start cowboy, we have to give cowboy an instance where to send the connection.

create a file lib/phonix_plug.ex
```elixir
defmodule Phonix.Plug do
  import Plug.Conn

  @spec init(Map.t) :: Map.t
  def init(opts), do: opts

  @spec call(Plug.Conn.t, Map.t) :: Plug.Conn.t
  def call(conn, _opts) do
    conn
    |> IO.inspect
    |> send_resp(200, "Hello")
    |> IO.inspect
  end
end
```
and start cowboy
```bash
bash\> iex -S mix
iex\> {:ok , pid }= Plug.Adapters.Cowboy.http(Phonix.Plug, %{}, port: 4001)
  ```
  goto http://localhost:4001

  as you can see in the iex shell you have the connection %Plug.Conn struct and its changes in the response-section

  #### 4 create your own pipeline
  For our own pipeline we have to use the Plug.Build. Now we can plug some other plugs into our pipeline or/and we can create easy our own plugs.

  ```elixir
  defmodule Phonix.Plug do
    use Plug.Builder

    plug Plug.Logger
    plug :hello

    @spec hello(Plug.Conn.t, Map.t) :: Plug.Conn.t
    def hello(conn, _opts) do
      conn
      |> send_resp(200, "Hello World")
    end
  end
  ```
  #### 4.1 do some more magic with the request-path
  We would like to show the string that is given after "/"


  ```elixir
  def hello(%Plug.Conn{request_path: "/"<>ext } = conn, _opts) do
    conn
    |> send_resp(200, "my extension is: #{ext}")
  end
  ```
  ... nice but...

  #### question
  How can we route now some different request-paths?

  #### 5 Plug.Router

  create a file lib/phonix_router.ex

  ```elixir
  defmodule Phonix.Router do
    use Plug.Router

    plug :match
    plug :dispatch
    plug Phonix.Plug

    get "/" do
      send_resp(conn, 200, "root-path and nothing to do here!")
    end

    get "/:name" do
      conn
    end

    match _ do
      send_resp(conn, 404, "oops")
    end

  end
  ```

  and change the entrypoint for cowboy

  ```bash
  bash\> iex -S mix
  iex\> {:ok , pid }= Plug.Adapters.Cowboy.http(Phonix.Router, %{}, port: 4001)
    ```
    #### 6 now add a plug-module that checks for specific extensions

    create a file lib/phonix_checker.ex

    ```elixir
    defmodule Phonix.Checker do
      import Plug.Conn

      def init(opts), do: opts

      def call(%Plug.Conn{request_path: "/" <> ext } = conn, _opts) do
        case Enum.member?(["User", "Users"], ext) do
          true ->
            conn
            false ->
              conn
              |> send_resp(404, "SOMETHNG WENT WRONG")
              |> halt
            end
          end

        end
        ```
        http://localhost:4001 shows the root-path text

        http://localhost:4001/User shows the extension-message

        http://localhost:4001/user shows SOMETHING WENT WRONG

        http://localhost:4001/foo/bar shows oops


        #### 7 add cowboy to the supervision-tree

        add the following line to lib/phonix/application.ex

        ```elixir
        children = [
          Plug.Adapters.Cowboy.child_spec(:http, Phonix.Router, %{}, [port: 4001])
        ]
        ```
        child_spec returns a corresponding adapter to supervise the Cowboy-plug-adapter.

        Finaly start the app in the shell
        ```bash
        bash\> iex -S mix
        ```
