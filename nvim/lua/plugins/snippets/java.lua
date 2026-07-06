local ls = require("luasnip")
local s = ls.snippet
local i = ls.insert_node
local rep = require("luasnip.extras").rep
local fmt = require("luasnip.extras.fmt").fmt

return {
  s(
    "maina",
    fmt(
      [[
    public static void main(String[] args) {{
      {}
    }}
  ]],
      { i(1) }
    )
  ),

  s(
    "pcm",
    fmt(
      [[
public class Main {{
  {}
}}
]],
      {
        i(1),
      }
    )
  ),

  s(
    "pcmm",
    fmt(
      [[
public class Main {{

  public static void main(String[] args) {{
    {}
  }}
}}
]],
      {
        i(1),
      }
    )
  ),

  s(
    "tryc",
    fmt(
      [[
try {{
  {};
}} catch ({} e) {{
  System.out.println("ERROR: " + e.getMessage());
}}
]],
      {
        i(1),
        i(2, "Exception"),
      }
    )
  ),

  s(
    "trycf",
    fmt(
      [[
try {{
  {};
}} catch ({} e) {{
  System.out.println("ERROR: " + e.getMessage());
}} finally {{
  {};
}}
]],
      {
        i(1),
        i(2, "Exception"),
        i(3),
      }
    )
  ),

  s(
    "trycr",
    fmt(
      [[
try ({}) {{
  {};
}} catch ({} e) {{
  System.out.println("ERROR: " + e.getMessage());
}}
]],
      {
        i(1, "resource"),
        i(2),
        i(3, "Exception"),
      }
    )
  ),

  s(
    "dow",
    fmt(
      [[
do {{
  {};
}} while ({});
]],
      {
        i(1),
        i(2, "condition"),
      }
    )
  ),

  s(
    "soup",
    fmt([[System.out.print("{}");]], {
      i(1),
    })
  ),

  s(
    "souf",
    fmt([[System.out.printf("{}", {});]], {
      i(1),
      i(2),
    })
  ),

  s(
    "pco",
    fmt(
      [[
public class {} {{
  {}
}}
]],
      {
        i(1, "ClassName"),
        i(2),
      }
    )
  ),

  s(
    "singl",
    fmt(
      [[
private static {} instance;

private {}() {{}}

public static {} getInstance() {{
  if (instance == null) {{
    instance = new {}();
  }}
  return instance;
}}

{}
]],
      {
        i(1, "ClassName"),
        rep(1),
        rep(1),
        rep(1),
        i(2),
      }
    )
  ),

  s(
    "forr",
    fmt(
      [[
for (int {} = {}.length - 1; {} >= 0; {}--) {{
  {}
}}
]],
      {
        i(1, "i"),
        i(2, "array"),
        rep(1),
        rep(1),
        i(3),
      }
    )
  ),

  s(
    "builder",
    fmt(
      [[
public static class Builder {{
  {}

  public Builder {}({} {}) {{
    this.{} = {};
    return this;
  }}

  public {} build() {{
    return new {}(this);
  }}
}}

{}
]],
      {
        i(1, "// fields"),
        i(2, "field"),
        i(3, "Type"),
        i(4, "value"),
        rep(4),
        rep(4),
        i(5, "ClassName"),
        rep(5),
        i(6),
      }
    )
  ),

  s(
    "rec",
    fmt(
      [[
public record {}({}) {{
  {}
}}
]],
      {
        i(1, "Name"),
        i(2),
        i(3),
      }
    )
  ),
}
