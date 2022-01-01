# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_6 python3_7 python3_8 pypy3 )

inherit distutils-r1

DESCRIPTION="Python implementation of the markdown markup language"
HOMEPAGE="
	https://python-markdown.github.io/
	https://pypi.org/project/Markdown/
	https://github.com/Python-Markdown/markdown"
SRC_URI="mirror://pypi/M/${PN^}/${P^}.tar.gz"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~mips ~ppc ~ppc64 ~sparc
~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc pygments"
RESTRICT="test"

# source cites pytidylib however from testruns it appears optional
RDEPEND="pygments? ( dev-python/pygments[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${P^}"

python_compile_all() {
	if use doc; then
		esetup.py build_docs
		HTML_DOCS=( "${BUILD_DIR}"/docs/. )

		# remove .txt files
		find "${BUILD_DIR}"/docs -name '*.txt' -delete || die
	fi
}
