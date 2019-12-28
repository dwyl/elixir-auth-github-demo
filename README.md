<div align="center">

# `elixir-auth-github` _demo_

A basic example/tutorial showing GitHub Auth in a Phoenix App
using [`elixir-auth-github`](https://github.com/dwyl/elixir-auth-github).

![Build Status](https://img.shields.io/travis/com/dwyl/elixir-auth-github-demo/master?color=bright-green&style=flat-square)
[![codecov.io](https://img.shields.io/codecov/c/github/dwyl/elixir-auth-github/master.svg?style=flat-square)](http://codecov.io/github/dwyl/elixir-auth-github?branch=master)
[![Hex.pm](https://img.shields.io/hexpm/v/elixir_auth_github?color=brightgreen&style=flat-square)](https://hex.pm/packages/elixir_auth_github)
[![contributions welcome](https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat-square)](https://github.com/dwyl/elixir-auth-github/issues)

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

If prompted to install dependencies `Fetch and install dependencies? [Yn]`
Type `y` and hit the `[Enter]` key to install.

You should see something like this:
```
* running mix deps.get
* running cd assets && npm install && node node_modules/webpack/bin/webpack.js
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
![phoenix-default-home](https://user-images.githubusercontent.com/194400/70126043-0d174b00-1670-11ea-856e-b31e593b5844.png)



## 1. Add the `elixir_auth_github` package to `mix.exs` 📦

Open your `mix.exs` file and add the following line to your `deps` list:

```elixir
def deps do
  [
    {:elixir_auth_github, "~> 1.0.0"}
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


# > `CONTINUE` _HERE_!

and add the following code:

```elixir
defmodule AppWeb.GithubAuthController do
  use AppWeb, :controller

  @doc """
  `index/2` handles the callback from GitHub Auth API redirect.
  """
  def index(conn, %{"code" => code}) do
    {:ok, token} = ElixirAuthGithub.get_token(code, conn)
    {:ok, profile} = ElixirAuthGithub.get_user_profile(token.access_token)
    conn
    |> put_view(AppWeb.PageView)
    |> render(:welcome, profile: profile)
  end
end
```
This code does 3 things:
+ Create a one-time auth token based on the response `code` sent by GitHub
after the person authenticates.
+ Request the person's profile data from GitHub based on the `access_token`
+ Render a `:welcome` view displaying some profile data
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
  <h1> Welcome <%= @profile.given_name %>!
  <img width="32px" src="<%= @profile.picture %>" />
  </h1>
  <p> You are <strong>signed in</strong>
    with your <strong>GitHub Account</strong> <br />
    <strong style="color:teal;"><%= @profile.email %></strong>
  <p/>
</section>
```

> **`TODO`**: update the profile Map:

The GitHub Auth API `get_profile` request
returns profile data in the following format:
```elixir
%{
  email: "nelson@gmail.com",
  email_verified: true,
  family_name: "Correia",
  given_name: "Nelson",
  locale: "en",
  name: "Nelson Correia",
  picture: "https://lh3.googleusercontent.com/a-/AAuE7mApnYb260YC1JY7",
  sub: "940732358705212133793"
}
```
You can use this data however you see fit.
(_obviously treat it with respect, only store what you need and keep it secure_)


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

> **`TODO`**: confirm that this is all the code we need:

To:
```elixir
def index(conn, _params) do
  oauth_github_url = ElixirAuthGithub.generate_oauth_url(conn)
  render(conn, "index.html",[oauth_github_url: oauth_github_url])
end
```

### 5.1 Update the `page/index.html.eex` Template

Open the `/lib/app_web/templates/page/index.html.eex` file
and type the following code:

> **`TODO`**: create button: https://github.com/dwyl/elixir-auth-github/issues/33

```html
<section class="phx-hero">
  <h1>Welcome to Awesome App!</h1>
  <p>To get started, login to your GitHub Account: <p>
  <a href="<%= @oauth_github_url %>">
    <img src="https://i.imgur.com/Kagbzkq.png" alt="Sign in with GitHub" />
  </a>
</section>
```

The home page of the app now has a big "Sign in with GitHub" button:

![sign-in-button](https://user-images.githubusercontent.com/194400/70202961-3c32c880-1713-11ea-9737-9121030ace06.png)

Once the person completes their authentication with GitHub,
they should see the following welcome message:

![welcome](https://user-images.githubusercontent.com/194400/70201692-494db880-170f-11ea-9776-0ffd1fdf5a72.png)


To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Install Node.js dependencies with `cd assets && npm install`
  * Start Phoenix endpoint with `mix phx.server`



<br />


## _Deployment_?

This guide is meant to get your Phoenix App up-and-running
with [elixir-auth-github](https://github.com/dwyl/elixir-auth-github)
on **`localhost`.
The demo is deployed to Heroku to demonstrate that the code works as expected.
If you want to deploy your App to Heroku,
we created a _separate_ guide for that!
see:
[/elixir-phoenix-app-deployment.md](https://github.com/dwyl/learn-heroku/blob/master/elixir-phoenix-app-deployment.md)
