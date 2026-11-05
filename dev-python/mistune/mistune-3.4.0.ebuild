# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_VERIFY_REPO=https://github.com/lepture/mistune
PYTHON_COMPAT=( python3_{12..15} python3_{14..15}t )

inherit distutils-r1 pypi

DESCRIPTION="The fastest markdown parser in pure Python"
HOMEPAGE="
	https://github.com/lepture/mistune/
	https://pypi.org/project/mistune/
"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~x64-macos"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest

EPYTEST_DESELECT=(
	# unreliable timing tests
	tests/test_misc.py::TestMiscCases::test_deeply_indented_list_does_not_scale_quadratically
	tests/test_security_formatting.py::TestFormattingSecurity::test_repeated_unclosed_formatting_markers_are_near_linear
	tests/test_security_inline.py::TestInlineParserSecurity::test_adjacent_ruby_tokens_do_not_recurse_forever
)
