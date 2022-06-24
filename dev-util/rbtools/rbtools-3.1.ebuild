# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8,9,10} )

inherit distutils-r1

MY_PN="RBTools"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Command line tools for use with Review Board"
HOMEPAGE="https://www.reviewboard.org/"
SRC_URI="https://downloads.reviewboard.org/releases/${MY_PN}/$(ver_cut 1-2)/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-python/pydiffx-1.0.1-r1[${PYTHON_USEDEP}]
	>=dev-python/six-1.8.0[${PYTHON_USEDEP}]
	dev-python/tqdm[${PYTHON_USEDEP}]
	dev-python/texttable[${PYTHON_USEDEP}]
	dev-python/colorama[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/kgb[${PYTHON_USEDEP}] )
"

DOCS=( AUTHORS NEWS README.md )

S=${WORKDIR}/${MY_P}

distutils_enable_tests nose

src_prepare() {
	default

	# Avoid tests requiring unpackaged test data
	rm -f rbtools/clients/tests/test_scanning.py || die

	# Avoid repository specific tests to avoid dependencies on them
	rm -f rbtools/clients/tests/test_{cvs,git,mercurial,svn}.py || die

	# Fix test that appears to expect case-insentive comparison
	sed -i -e 's/TEST CONTENT/Test content/' rbtools/utils/tests/test_console.py || die
}

python_test() {
	distutils_install_for_testing
	distutils-r1_python_test
}
