local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local l = extras.lambda
local rep = extras.rep
local p = extras.partial
local m = extras.match
local n = extras.nonempty
local dl = extras.dynamic_lambda
local fmt = require("luasnip.extras.fmt").fmt
local fmta = require("luasnip.extras.fmt").fmta
local conds = require("luasnip.extras.expand_conditions")
local postfix = require("luasnip.extras.postfix").postfix
local types = require("luasnip.util.types")
local parse = require("luasnip.util.parser").parse_snippet
local ms = ls.multi_snippet
local k = require("luasnip.nodes.key_indexer").new_key

local function copy(args)
	return args[1]
end

local function basename ()
    return vim.fn.expand("%:t:r")
end

return {
    s("myclass", {
        t("class "), f(basename),
        t({" {", "public:", "\t"}), f(basename),
        t({"();", "\t"}), f(basename),
        t("(const "), f(basename),
        t({"&);","\t~"}), f(basename),
        t({"();", "", "\t"}), f(basename),
        t(" &operator=(const "), f(basename),
        t({"&);", "private:", ""}),
        t("};")
    }),
    s("classd", {
        t("#include \""), f(basename), t({".hpp\"", "", ""}),
        f(basename), t("::"), f(basename), t("()"), i(2), t({" {}", "", ""}),
        f(basename), t("::~"), f(basename), t({"() {}", "", ""}),
        f(basename), t("::"), f(basename), t("(const "), f(basename), t({
            " &other) {",
            "\t(void) other;",
            "}",
            "",
            ""
        }),
        f(basename), t(" &"), f(basename), t("::operator=(const "),
        f(basename), t({
            " &other) {",
            "\tif (&other == this)",
            "\t\treturn (*this);",
            "\treturn (*this);",
            "}",
        })
    }),
    s("exception", {
        t("class "), i(1, "MyException"), t({
            ": public std::exception {",
            "public:", "\t"}),
        f(copy, 1),
        t("(const std::string &msg = \""),
        f(copy, 1),
        t({" happened.\") throw() :",
            "\t\t_message(msg) {}",
            "virtual ~",
        }),
        f(copy, 1),
        t({
        "() throw() {}",
        "\tconst char *what() const throw() {",
            "\t\treturn (_message.c_str());",
        "\t}",
        "private:",
        "\tstd::string _message;",
    "};"})
    })
}
