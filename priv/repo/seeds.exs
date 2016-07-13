# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     ExPusherLite.Repo.insert!(%ExPusherLite.SomeModel{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias ExPusherLite.App
alias ExPusherLite.Repo

# not using the App.changeset should just avoid all validations and generations
Repo.insert! %App{
  slug: "name-of-the-client-application",
  name: "Some Description Name for the Client Application",
  key: "secret-key-1234567890",
  secret: "secret-0987654321",
  active: true }
