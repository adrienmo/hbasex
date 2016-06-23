defmodule Hbasex.Mixfile do
  use Mix.Project

  @version File.read!("VERSION") |> String.strip

  def project do
    [app: :hbasex,
     version: @version,
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     #comment out thrift file gen
     #compilers: [:thrift | Mix.compilers],
     #thrift_files: Mix.Utils.extract_files(["thrift"], [:thrift]),
     elixirc_options: [warnings_as_errors: true],
     deps: deps]
  end

  def application do
    [applications: [:logger]]
  end

  defp deps do
    [{:riffed, github: "pinterest/riffed", tag: "1.0.0", submodules: true}]
  end
end
