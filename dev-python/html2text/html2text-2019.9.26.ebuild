# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( pypy3 python3_{6,7} )

inherit distutils-r1

DESCRIPTION="Turn HTML into equivalent Markdown-structured text"
HOMEPAGE="https://github.com/Alir3z4/html2text https://pypi.org/project/html2text/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

# pkg_resources is used for entry points
RDEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

DOCS=( AUTHORS.rst ChangeLog.rst README.md )

python_prepare_all() {
	# naming conflict with app-text/html2text, bug 421647
	sed -i 's/html2text = html2text.cli:main/py\0/' setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	pytest -vv || die "tests failed with ${EPYTHON}"
}
