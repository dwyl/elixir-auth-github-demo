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

**We _love_** having _**detailed docs** and **examples**_
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
Get help by opening an issue: 
[dwyl/elixir-auth-github/issues](https://github.com/dwyl/elixir-auth-github/issues)

# _How?_ 💻

This example follows the step-by-instructions in the docs
[dwyl/elixir-auth-github](https://github.com/dwyl/elixir-auth-github)


## 0. Create a New Phoenix App

Create a new project if you don't already have one:

> _If you're adding `elixir_auth_github` to an **existing app**,
you can **skip this step**. <br />
Just make sure your app is in a known working state before proceeding_.

```
mix phx.new app 
```

> **Note**: In creating this demo app 
> we ran the command with the following 
> [**flags**](https://hexdocs.pm/phoenix/Mix.Tasks.Phx.New.html):
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
    {:elixir_auth_github, "~> 1.6.5"}
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

## 3. Create 3 New Files  ➕

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
    render(conn, :welcome, [layout: false, profile: profile])
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
`lib/app_web/controllers/github_auth_html/welcome.html.heex`

And type (_or paste_) the following code in it:
```html
<script src="https://cdn.tailwindcss.com"></script>

<section class="flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-screen lg:py-0">
  <h1 class="text-4xl text-center font-bold leading-tight tracking-tight text-gray-900 md:text-2xl">
    Welcome <%= @profile.name %>!
    <img class="float-right h-8 w-8 rounded-full" alt="avatar image" width="32px" 
      src={@profile.avatar_url} />
  </h1>
  <p> You are <strong>signed in</strong>
    with your <strong>GitHub Account</strong> <br />
    <strong style="color:teal;"><%= @profile.email %></strong>
  </p>
</section>
```

> **Note**: There's a fair amount of `TailwindCSS` sprinkled in that template,
if you're new to `Tailwind` or need a refresher,
please see: 
[/learn-tailwind](https://github.com/dwyl/learn-tailwind)


Invoking `ElixirAuthGithub.github_auth(code)`
in the `GithubAuthController`
`index` function will
make an HTTP request to the GitHub Auth API
and will return `{:ok, profile}`
where the `profile` data
has the following format:

```elixir
%{
  followers_url: "https://api.github.com/users/nelsonic/followers",
  public_repos: 291,
  plan: %{
    "collaborators" => 0,
    "name" => "pro",
    "private_repos" => 9999,
    "space" => 976562499
  },
  created_at: "2010-02-02T08:44:49Z",
  name: "Nelson",
  company: "@dwyl",
  email: "nelson@gmail.com",
  two_factor_authentication: true,
  starred_url: "https://api.github.com/users/nelsonic/starred{/owner}{/repo}",
  id: 194400,
  following: 173,
  login: "nelsonic",
  collaborators: 28,
  avatar_url: "https://avatars3.githubusercontent.com/u/194400?v=4",
  etc: "you get the idea ..."
}
```

More info: https://developer.github.com/v3/users

Use this data how you see fit.
(_obviously treat it with respect,
  only store what you need and keep it secure!_)

### 3.3 Create the 

Create a file with the path:
`lib/app_web/controllers/github_auth_html.ex`

and add the following code to it:

```elixir
defmodule AppWeb.GithubAuthHTML do
  use AppWeb, :html

  embed_templates "github_auth_html/*"
end
```


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
  def home(conn, _params) do
    # The home page is often custom made,
    # so skip the default app layout.
    render(conn, :home, layout: false)
  end
```

To:
```elixir
def home(conn, _params) do
  oauth_github_url = ElixirAuthGithub.login_url_with_scope(["user:email"])
  render(conn, :home, [layout: false, oauth_github_url: oauth_github_url])
end
```

### 5.1 Update the `page/index.html.eex` Template

Open the `/lib/app_web/controllers/page_html/home.html.heex` file
and type (_or paste_) the following code:

```html
<script src="https://cdn.tailwindcss.com"></script>

<section class="">
  <div class="flex flex-col items-center justify-center px-6 py-8 mx-auto md:h-screen lg:py-0">
      <div class="w-full bg-white rounded-lg shadow dark:border md:mt-0 sm:max-w-md xl:p-0 dark:bg-gray-200 dark:border-gray-700">
          <div class="p-6 space-y-4 md:space-y-6 sm:p-8">
              <h1 class="text-3xl text-center font-bold leading-tight tracking-tight text-gray-900 md:text-2xl">
                Welcome to Awesome App!
              </h1>
              <p class="text-center">
                To get started, login with your GitHub Account:
              </p>
              <a href={ @oauth_github_url } class="py-8 flex items-center justify-center">
                <img src="https://i.imgur.com/qwoHBIZ.png" alt="Sign in with GitHub" />
              </a>
          </div>
      </div>
  </div>
</section>
```

> **Note**: the login button is an image for brevity.
> In our production version we use `CSS` and `SVG`,
> see: 
> [/elixir-auth-github#optimised-svgcss-button](https://github.com/dwyl/elixir-auth-github#optimised-svgcss-button)

## 6. _Run_ the App!

Run the app with the command:

```sh
mix phx.server
```

Visit the  home page of the app
where you will see a
"Sign in with GitHub" button:
http://localhost:4000

![sign-in-button](https://github.com/dwyl/elixir-auth-github-demo/assets/194400/8942e6a1-6b5a-4e09-99cb-7924e0631acd)

Once the user authorizes the App,
they will be redirected
back to the Phoenix App
and will see welcome message:

![welcome](https://github.com/dwyl/elixir-auth-github-demo/assets/194400/c1a8bf8e-e1ed-4d69-8b1e-93b2ad6ca003)


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



