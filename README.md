<div align="center">

# `elixir-auth-github` _demo_

A basic example/tutorial showing **GitHub OAuth** in a **`Phoenix` App**
using [**`elixir-auth-github`**](https://github.com/dwyl/elixir-auth-github).

![GitHub Workflow Status](https://img.shields.io/github/actions/workflow/status/dwyl/elixir-auth-github-demo/ci.yml?label=build&style=flat-square&branch=main)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/elixir-auth-github-demo/main.svg?style=flat-square)](http://codecov.io/github/dwyl/elixir-auth-github-demo?branch=main)
[![Hex.pm](https://img.shields.io/hexpm/v/elixir_auth_github?color=brightgreen&style=flat-square)](https://hex.pm/packages/elixir_auth_github)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square)](https://github.com/dwyl/elixir-auth-github/issues)
[![HitCount](https://hits.dwyl.com/dwyl/app-elixir-auth-github-demo.svg)](https://hits.dwyl.com/dwyl/app-elixir-auth-github-demo)

</div>

# _Why_? 🤷

As developers we are _always learning_ new things.
When we learn, we love having _detailed docs and **examples**_
that explain _exactly_ how to get up-and-running.
We _write_ examples because we want them for _ourselves_,
if you find them useful, please ⭐️ the repo to let us know.


# _What_? 💭

This project is a _barebones_ demo
of using
[`elixir-auth-github`](https://github.com/dwyl/elixir-auth-github)
to add "***Sign-in with GitHub***" support
to any Phoenix App.

# _Who_? 👥

This demos is intended for people of all Elixir/Phoenix skill levels.
Anyone who wants the "***Sign-in with GitHub***" functionality
without the extra steps to configure a whole auth _framework_.

Following all the steps in this example should take around 10 minutes.
However if you get stuck, please don't suffer in silence!
Get help by opening an issue: https://github.com/dwyl/elixir-auth-github/issues

# _How?_ 💻

This example follows the step-by-instructions in the docs
[github.com/dwyl/elixir-auth-github](https://github.com/dwyl/elixir-auth-github)


## 0. Create a New Phoenix App

Create a new project if you don't already have one:

> _If you're adding `elixir_auth_github` to an **existing app**,
you can **skip this step**. <br />
Just make sure your app is in a known working state before proceeding_.

```
mix phx.new app 
```

> **Note**: In creating this demo app 
> we actually ran the command with the following 
> [flags](https://hexdocs.pm/phoenix/Mix.Tasks.Phx.New.html):
> `mix phx.new app --no-assets --no-dashboard --no-ecto --no-gettext --no-mailer`
> to keep the project as basic as possible. 
> You may need some or all of the features of `Phoenix`,
> so check which flags are applicable to you.

If prompted to install dependencies:
```
Fetch and install dependencies? [Yn]
```

Type `y` and hit the `[Enter]` key to install.

You should see something like this:
```
* running mix deps.get
* running mix deps.compile
```

Make sure that everything works before proceeding:
```
mix test
```
You should see:
```
Generated app app
...

Finished in 0.02 seconds
3 tests, 0 failures
```
The default tests pass and you know phoenix is compiling.

Run the web application:

```
mix phx.server
```

and visit the endpoint in your web browser: http://localhost:4000/
![phoenix-default-home](https://github.com/dwyl/elixir-auth-github-demo/assets/194400/3912c4af-b6e4-469c-be9f-7b5cdb3fee18)



## 1. Add the `elixir_auth_github` package to `mix.exs` 📦

Open your `mix.exs` file and add the following line to your `deps` list:

```elixir
def deps do
  [
    {:elixir_auth_github, "~> 1.6.0"}
  ]
end
```
Run the **`mix deps.get`** command to download.



## 2. Create the GitHub OAuth Application and Get Credentials ✨

Create your GitHub App and download the API keys
by follow the instructions in:
[`/create-github-app-guide.md`](https://github.com/dwyl/elixir-auth-github/blob/master/create-github-app-guide.md)

By the end of this step
you should have these two environment variables defined:

```yml
GITHUB_CLIENT_ID=631770888008-6n0oruvsm16kbkqg6u76p5cv5kfkcekt
GITHUB_CLIENT_SECRET=MHxv6-RGF5nheXnxh1b0LNDq
```

> ⚠️ Don't worry, these keys aren't valid.
They are just here for illustration purposes.

## 3. Create 2 New Files  ➕

We need to create two files in order to handle the requests
to the GitHub OAuth API and display data to people using our app.

### 3.1 Create a `GithubAuthController` in your Project

In order to process and _display_ the data returned by the GitHub OAuth2 API,
we need to create a new `controller`.

Create a new file called
`lib/app_web/controllers/github_auth_controller.ex`

and add the following code:

```elixir
defmodule AppWeb.GithubAuthController do
  use AppWeb, :controller

  @doc """
  `index/2` handles the callback from GitHub Auth API redirect.
  """
  def index(conn, %{"code" => code}) do
    {:ok, profile} = ElixirAuthGithub.github_auth(code)
    conn
    |> put_view(AppWeb.PageView)
    |> render(:welcome, profile: profile)
  end
end
```

This code does 3 things:
+ Create a one-time auth token based on the response `code` sent by GitHub
after the person authenticates.
+ Request the person's profile data from GitHub based on an `access_token`
+ Renders a `:welcome` view displaying some profile data
to confirm that login with GitHub was successful.

> Note: we are placing the `welcome.html.eex` template
in the `template/page` directory to save having to create
any more directories and view files.
You are free to organise your code however you prefer.

### 3.2 Create `welcome` template 📝

Create a new file with the following path:
`lib/app_web/templates/page/welcome.html.eex`

And type (_or paste_) the following code in it:
```html
<section class="phx-hero">
  <h1> Welcome <%= @profile.name %>!
  <img width="32px" src="<%= @profile.avatar_url %>" />
  </h1>
  <p> You are <strong>signed in</strong>
    with your <strong>GitHub Account</strong> <br />
    <strong style="color:teal;"><%= @profile.email %></strong>
  </p>
</section>
```

Invoking `ElixirAuthGithub.github_auth(code)`
in the `GithubAuthController`
`index` function will
make an HTTP request to the GitHub Auth API
and will return `{:ok, profile}`
where the `profile`
is the following format:

```elixir
%{
  site_admin: false,
  disk_usage: 265154,
  access_token: "8eeb143935d1a505692aaef856db9b4da8245f3c",
  private_gists: 0,
  followers_url: "https://api.github.com/users/nelsonic/followers",
  public_repos: 291,
  gists_url: "https://api.github.com/users/nelsonic/gists{/gist_id}",
  subscriptions_url: "https://api.github.com/users/nelsonic/subscriptions",
  plan: %{
    "collaborators" => 0,
    "name" => "pro",
    "private_repos" => 9999,
    "space" => 976562499
  },
  node_id: "MDQ6VXNlcjE5NDQwMA==",
  created_at: "2010-02-02T08:44:49Z",
  blog: "https://www.dwyl.io/",
  type: "User",
  bio: "Learn something new every day. github.com/dwyl/?q=learn",
  following_url: "https://api.github.com/users/nelsonic/following{/other_user}",
  repos_url: "https://api.github.com/users/nelsonic/repos",
  total_private_repos: 5,
  html_url: "https://github.com/nelsonic",
  public_gists: 29,
  avatar_url: "https://avatars3.githubusercontent.com/u/194400?v=4",
  organizations_url: "https://api.github.com/users/nelsonic/orgs",
  url: "https://api.github.com/users/nelsonic",
  followers: 2778,
  updated_at: "2020-02-01T21:14:20Z",
  location: "London",
  hireable: nil,
  name: "Nelson",
  owned_private_repos: 5,
  company: "@dwyl",
  email: "nelson@gmail.com",
  two_factor_authentication: true,
  starred_url: "https://api.github.com/users/nelsonic/starred{/owner}{/repo}",
  id: 194400,
  following: 173,
  login: "nelsonic",
  collaborators: 8
}
```

More info: https://developer.github.com/v3/users

You can use this data however you see fit.
(_obviously treat it with respect,
  only store what you need and keep it secure_)


## 4. Add the `/auth/github/callback` to `router.ex`

Open your `lib/app_web/router.ex` file
and locate the section that looks like `scope "/", AppWeb do`

Add the following line:

```elixir
get "/auth/github/callback", GithubAuthController, :index
```

That will direct the API request response
to the `GithubAuthController` `:index` function we defined above.


## 5. Update `PageController.index`

In order to display the "Sign-in with GitHub" button in the UI,
we need to _generate_ the URL for the button in the relevant controller,
and pass it to the template.

Open the `lib/app_web/controllers/page_controller.ex` file
and update the `index` function:

From:
```elixir
def index(conn, _params) do
  render(conn, "index.html")
end
```

To:
```elixir
def index(conn, _params) do
  oauth_github_url = ElixirAuthGithub.login_url_with_scope(["user:email"])
  render(conn, "index.html", [oauth_github_url: oauth_github_url])
end
```

### 5.1 Update the `page/index.html.eex` Template

Open the `/lib/app_web/templates/page/index.html.eex` file
and type (_or paste_) the following code:

> **`TODO`**: create button: https://github.com/dwyl/elixir-auth-github/issues/33

```html
<section class="phx-hero">
  <h1>Welcome to Awesome App!</h1>
  <p>To get started, login to your GitHub Account: <p>
  <a href="<%= @oauth_github_url %>">
    <img src="https://i.imgur.com/qwoHBIZ.png" alt="Sign in with GitHub" />
  </a>
</section>
```

## 6. _Run_ the App!

Run the app with the command:

```sh
mix phx.server
```

Visit the  home page of the app
where you will see a
"Sign in with GitHub" button:
http://localhost:4000

![sign-in-button](https://user-images.githubusercontent.com/194400/73599088-91366380-4537-11ea-84aa-b473da4ca379.png)

Once the user authorizes the App,
they will be redirected
back to the Phoenix App
and will see welcome message:

![welcome](https://user-images.githubusercontent.com/194400/73599112-e8d4cf00-4537-11ea-8379-a58affbea560.png)


<br />


## _Deployment_?

This guide is meant to get your `Phoenix` App up-and-running
with [elixir-auth-github](https://github.com/dwyl/elixir-auth-github)
on **`localhost`**.

The demo is deployed to Fly.io
to demonstrate that everything works as expected:


No data is saved by the demo app,
so feel free to try an _break_ it!

https://elixir-auth-github-demo.fly.dev

<img width="752" alt="image" src="https://user-images.githubusercontent.com/194400/218129527-716ea174-bc3d-4070-a02e-c53dc3c51fff.png">

Authorization screen:

<img width="817" alt="image" src="https://user-images.githubusercontent.com/194400/218129641-1c64cae7-3eb9-4616-b92e-a96f7b779ad8.png">

Welcome (success):

<img width="867" alt="image" src="https://user-images.githubusercontent.com/194400/218129788-6880e9d6-94e1-4966-8920-5cb0253f9ce1.png">


### Deploy to Fly.io

If you want to deploy your own `Phoenix` App to Fly.io,
simply follow the official `Elixir` Getting Started guide:
[fly.io/docs/elixir/getting-started](https://fly.io/docs/elixir/getting-started/)

```sh
fly launch
```

Speed through the prompts to create the App
and then add the add the 3 required environment variables:

```sh
fly secrets set GITHUB_CLIENT_ID=4458109151751aetc
fly secrets set GITHUB_CLIENT_SECRET=256df107df6454001a90d667fetc
SECRET_KEY_BASE=fephli94y1u1X7F8Snh9RUvz5l0fd1ySaz9WtzaUAX+NmfB0uE2xwetc
```

> **Note**: _none_ of these keys are valid. 
> They are just for illustration purposes.
> Follow the instructions:
> [dwyl/elixir-auth-google/blob/main/create-google-app-guide.md](https://github.com/dwyl/elixir-auth-google/blob/main/create-google-app-guide.md)
> to get your Google App keys.

Refer to the
`Dockerfile` 
and
`fly.toml`
in this demo project
if you need an example.

[elixir-google-auth-demo.fly.dev](https://elixir-google-auth-demo.fly.dev/)

![elixir-google-auth-demo.fly.dev](https://user-images.githubusercontent.com/194400/217935199-2aa46e54-6977-4333-a3ac-22feab777004.png "works flawlessly")

Recommended reading: 
"Deploying with Releases"
[hexdocs.pm/phoenix/releases.html](https://hexdocs.pm/phoenix/releases.html)

For Continuous Deployment to Fly.io,
read:
[fly.io/docs/app-guides/continuous-deployment-with-github-actions](https://fly.io/docs/app-guides/continuous-deployment-with-github-actions/)



