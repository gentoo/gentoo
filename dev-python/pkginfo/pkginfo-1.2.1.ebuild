# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5} pypy )

inherit distutils-r1

DESCRIPTION="Provides an API for querying the distutils metadata written in a PKG-INFO file"
HOMEPAGE="https://pypi.python.org/pypi/pkginfo"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86"
IUSE="doc examples"

LICENSE="MIT"
SLOT="0"
DEPEND="doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
	dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}"

python_prepare_all() {
	sed -e 's:SPHINXBUILD   = sphinx-build:SPHINXBUILD   = /usr/bin/sphinx-build:' \
		-i docs/Makefile || die

	# Disable tests that seek to read the version of pkginfo from an installed state
	# These test will still become installed and testable once installed
	sed -e 's:test_w_directory_no_EGG_INFO:_&:' \
		-e 's:test_w_module_and_metadata_version:_&:' \
		-e 's:test_w_package_name_and_metadata_version:_&:' \
		-i pkginfo/tests/test_utils.py || die
	sed -e 's:test_ctor_w_path_nested_egg_info:_&:' \
		-i pkginfo/tests/test_develop.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	"${PYTHON}" -m unittest discover || die "Test ${test} failed under ${EPYTHON}"
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/.build/html/. )
	use examples && local EXAMPLES=( docs/examples/. )
	distutils-r1_python_install_all
}
