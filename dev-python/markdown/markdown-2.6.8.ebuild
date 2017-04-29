# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Python implementation of the markdown markup language"
HOMEPAGE="
	http://www.freewisdom.org/projects/python-markdown
	https://pypi.python.org/pypi/Markdown
	https://pythonhosted.org/Markdown/
	https://github.com/waylan/Python-Markdown"
SRC_URI="mirror://pypi/M/${PN^}/${P^}.tar.gz"

LICENSE="|| ( BSD GPL-2 )"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="doc test pygments"

DEPEND="
	test? (
		dev-python/nose[${PYTHON_USEDEP}]
		dev-python/pyyaml[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		dev-python/pytidylib[${PYTHON_USEDEP}]
	)"
# source cites pytidylib however from testruns it appears optional
RDEPEND="pygments? ( dev-python/pygments[${PYTHON_USEDEP}] )"

S="${WORKDIR}/${P^}"
PATCHES=(
	# build system always builds docs
	"${FILESDIR}"/${PN}-2.6.8-dont-build-docs-default.patch
)

python_compile_all() {
	if use doc; then
		esetup.py build_docs
		HTML_DOCS=( "${BUILD_DIR}"/docs/. )

		# remove .txt files
		find "${BUILD_DIR}"/docs -name '*.txt' -delete || die
	fi
}

python_test() {
	cp -r -l run-tests.py tests "${BUILD_DIR}"/ || die
	cd "${BUILD_DIR}" || die
	"${EPYTHON}" run-tests.py || die "Tests fail with ${EPYTHON}"
}
