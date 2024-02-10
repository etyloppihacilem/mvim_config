local function copy(args)
	return args[1]
end
return {
    s("myclass", {
        t("class "), i(1, "MyClass"),
        t({" {", "public:", "\t"}), f(copy, (1)),
        t({"();", "\t"}), f(copy, (1)),
        t("(const "), f(copy, 1),
        t({"&);","\t~"}), f(copy, 1),
        t({"();", "", "\t"}), f(copy, 1),
        t(" &operator=(const "), f(copy, 1),
        t({" &);", "private:", ""}),
        t("};")
    }),
    s("classd", {
        t("#include \""), f(copy, 1), t({".hpp\"", "", ""}),
        f(copy, 1), t("::"), i(1, "MyClass"), t("()"), i(2), t({" {}", "", ""}),
        f(copy, 1), t("::~"), f(copy, 1), t({"() {}", "", ""}),
        f(copy, 1), t("::"), f(copy, 1), t("(const "), f(copy, 1), t({
            "& other) {",
            "\t(void) other;",
            "}",
            "",
            ""
        }),
        f(copy, 1), t("& "), f(copy, 1), t("::operator=(const "),
        f(copy, 1), t({
            "& other) {",
            "\tif (&other == this) //coucou",
            "\t\treturn (*this);",
            "\t return (*this)",
            "}",
            ""
        })
    })
}
