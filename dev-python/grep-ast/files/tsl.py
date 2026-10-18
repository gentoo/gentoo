from tree_sitter import Language, Parser
import tree_sitter_bash
import tree_sitter_c
import tree_sitter_cmake
import tree_sitter_cpp
import tree_sitter_css
import tree_sitter_html
import tree_sitter_javascript
import tree_sitter_markdown
import tree_sitter_python
import tree_sitter_xml

USING_TSL_PACK = True

LANGUAGE_MAPPING = {
        "bash": tree_sitter_bash.language(),
        "c": tree_sitter_c.language(),
        "cmake": tree_sitter_cmake.language(),
        "cpp": tree_sitter_cpp.language(),
        "css": tree_sitter_css.language(),
        "dtd": tree_sitter_xml.language_dtd(),
        "html": tree_sitter_html.language(),
        "javascript": tree_sitter_javascript.language(),
        "markdown": tree_sitter_markdown.language(),
        "markdown_inline": tree_sitter_markdown.inline_language(),
        "python": tree_sitter_python.language(),
        "xml": tree_sitter_xml.language_xml(),
}

def get_language(lang: str):
    if lang in LANGUAGE_MAPPING:
        return Language(LANGUAGE_MAPPING[lang])
    raise ValueError(f"Unsupported language: {lang}")

def get_parser(lang: str):
    lang_obj = get_language(lang)
    parser = Parser(lang_obj)
    return parser

__all__ = [get_parser, get_language, USING_TSL_PACK]
