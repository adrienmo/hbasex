defmodule Hbasex.Mixfile do
  use Mix.Project

  @version File.read!("VERSION") |> String.strip

  def project do
    [app: :hbasex,
     version: @version,
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     ##### Uncomment those two lines to generate the /src folder
     # compilers: [:thrift | Mix.compilers],
     # thrift_files: Mix.Utils.extract_files(["thrift"], [:thrift]),
     description: "A HBase driver for Elixir using HBase Thrift Interface (v2)",
     elixirc_options: [warnings_as_errors: true],
     package: package,
     deps: deps]
  end

  def application do
    [applications: [:logger], mod: {Hbasex, []}]
  end

  defp deps do
    [
      {:riffed, github: "pinterest/riffed", tag: "1.0.0", submodules: true},
      {:poolboy, "~> 1.5"}
    ]
  end

  defp package do
    [
      files: ~w(lib src README.md LICENSE VERSION mix.exs),
      maintainers: ["Adrien Moreau"],
      licenses: ["MIT"],
      links: %{github: "https://github.com/adrienmo/hbasex"}
    ]
  end
end
