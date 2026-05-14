defmodule Erlex.ParserConflictsTest do
  use ExUnit.Case

  @parser_src Path.expand("../src/erlex_parser.yrl", __DIR__)

  test "parser compiles without conflict warnings" do
    tmp_id = System.unique_integer([:positive])
    tmp_dir = System.tmp_dir!()
    tmp_parser_expect = Path.join(tmp_dir, "erlex_parser_expect_#{tmp_id}.erl")

    try do
      {:ok, _parser, warnings} = yecc_file(@parser_src, tmp_parser_expect)
      assert warnings == []
    after
      _ = File.rm(tmp_parser_expect)
    end
  end

  defp yecc_file(src, parser) do
    :yecc.file(String.to_charlist(src),
      return_warnings: true,
      report_warnings: false,
      return_errors: true,
      report_errors: false,
      parserfile: String.to_charlist(parser)
    )
  end
end
