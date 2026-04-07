local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local fmta = require("luasnip.extras.fmt").fmta

return{
  s(
    {
      trig = "€",
      snippetType = "autosnippet",
    },
    {
      t("\\exists")
    }
  ),

  s(
    {
      trig = "n€",
      snippetType = "autosnippet",
    },
    {
      t("\\nexists")
    }
  ),

  s(
    {
      trig = "¢",
      snippetType = "autosnippet",
    },
    {
      t("\\subseteq")
    }
  ),

  s(
    {
      trig = "©",
      snippetType = "autosnippet",
    },
    {
      t("\\supseteq")
    }
  ),

  s(
    {
      trig = "„",
      snippetType = "autosnippet",
    },
    {
      t("\\forall")
    }
  ),

  s(
    {
      trig = "»",
      snippetType = "autosnippet",
    },
    {
      t("\\implies")
    }
  ),

  s(
    {
      trig = "ð",
      snippetType = "autosnippet",
    },
      fmta(
      [[
      \frac{\partial}{\partial<>}
      ]],
      { i(1) }
    )
  ),

  s(
    {
      trig = "→",
      snippetType = "autosnippet",
    },
      fmta(
      [[
      \int_{<>}^{<>}
      ]],
      { i(1), i(2) }
    )
  ),

}
