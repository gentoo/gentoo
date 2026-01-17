# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=hatchling
PYTHON_COMPAT=( python3_{11..14} pypy3_11 )

inherit distutils-r1 pypi

DESCRIPTION="Pythonic idioms for iterating, searching, and modifying an HTML/XML parse tree"
HOMEPAGE="
	https://www.crummy.com/software/BeautifulSoup/bs4/
	https://pypi.org/project/beautifulsoup4/
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos"

RDEPEND="
	dev-python/html5lib[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	>=dev-python/soupsieve-2.6[${PYTHON_USEDEP}]
	>=dev-python/typing-extensions-4.0.0[${PYTHON_USEDEP}]
"
# bs4 prefers cchardet > chardet > charset-normalizer
# however, charset-normalizer causes test failures, so force the other two
# dev-python/chardet[${PYTHON_USEDEP}]
BDEPEND="
	test? (
		|| (
			dev-python/faust-cchardet[${PYTHON_USEDEP}]
			dev-python/chardet[${PYTHON_USEDEP}]
		)
		dev-python/packaging[${PYTHON_USEDEP}]
	)
"

EPYTEST_PLUGINS=()
distutils_enable_tests pytest
distutils_enable_sphinx doc

EPYTEST_DESELECT=(
	# broken by security backports, already skipped on py3.13+
	"bs4/tests/test_fuzz.py::TestFuzz::test_rejected_markup[crash-ffbdfa8a2b26f13537b68d3794b0478a4090ee4a]"
)
