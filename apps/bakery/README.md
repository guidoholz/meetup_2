# Bakery

#### 1 create your bakery
```bash
bash\> mix phoenix.create bakery --no-ecto
bash\> cd bakery
bash\> mix deps.get
bash\> mix deps.compile
```

#### 2 hook up a route to a controller
edit web/router.ex
```elixir
scope "/", Bakery do
  ...
  get "/cookiejar", CookiejarController, :show
end
```
and start the server
```bash
bash\> iex -S mix phoenix.server
```
 goto http://localhost:4000

#### 3 create CookiejarController

create file web/controller/cookiejar_controller.ex

normaly we have to do the following, because a controller is a plug
```elixir
defmodule Bakery.CookiejarController do
  def init(opts), do: opts
  def call(conn, opts), do: conn
end
```

but instead we use the macro for controllers served by phoenix

```elixir
defmodule Bakery.CookiejarController do
  use Bakery.Web, :controller  
end
```

next we have to add the show function
```elixir
defmodule Bakery.CookiejarController do
  use Bakery.Web, :controller

  def show(conn, _opts) do
    conn |> render "show.html"
  end
end
```

#### 3 create a view
create file views/cookiejar_view.ex

```elixir
defmodule Bakery.CookiejarView do
  def render("show.html", _) do
    "YUMMIE"
  end
end
```

but instead we use the default macro for views

```elixir
defmodule Bakery.CookiejarView do
  use Bakery.Web, :view
end
```

#### 4 create the html

create file web/templates/cookiejar/show.html.eex

```html
<div id="test">
  <ul></ul>
</div>
```

#### 5 showing all cookies in the listing

add to web/static/js/app.js

```javascript
import $ from "jquery"

var cookies = document.cookie.split(';');
var cList = $('#test ul');
$.each(cookies, function(i)
{
  cList.append($("<li>").text(cookies[i]));
});
```

and run

```bash
bash\> npm install -S jquery
bash\> node node_modules/brunch/bin/brunch build
```

#### 6 put some cookies into the jar

edit web/templates/cookiejar/show.html.eex

```html
<div id="test">
  <ul></ul>
</div>

<%= form_tag("/cookiejar", method: :post) %>
  Flavor: <input type="text" name="flavor">
  <button type="submit">bake a cookie</button>
</form>
```

#### 7 add post-request to route

edit web/router.ex
```elixir
scope "/", Bakery do
  ...
  get "/cookiejar", CookiejarController, :show
  post "/cookiejar", CookiejarController, :show
end
```

but no new cookie is in the cookie-list

#### writing our cookie-plug

create file lib/bakery/bake_it.ex

```elixir
defmodule Bakery.BakeIt do
  import Plug.Conn

  def init(conn), do: conn

  def call(%Plug.Conn{body_params: %{"flavor" => flavor} } = conn, _opts) do
    case flavor do
      nil    -> conn
      flavor -> conn |> put_resp_cookie("flavor", flavor, http_only: false)
    end
    |> IO.inspect
  end

  def call(conn,_), do: conn

end
```

and plug it into the plug-pipeline

edit web/router.ex

```elixir
...
pipeline :browser do
  plug :accepts, ["html"]
  plug :fetch_session
  plug :fetch_flash
  plug :protect_from_forgery
  plug :put_secure_browser_headers
  plug Bakery.BakeIt
end
...
```
