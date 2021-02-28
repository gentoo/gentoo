# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{7..9} )
PYTHON_REQ_USE="tk"

inherit distutils-r1 virtualx

MY_PN="Pmw"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Toolkit for building high-level compound Python widgets using the Tkinter module"
HOMEPAGE="http://pmw.sourceforge.net/"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="py3"
KEYWORDS="~alpha amd64 ~ia64 ppc sparc x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc test"

DEPEND="!dev-python/pmw:0"
RDEPEND="${DEPEND}"
# https://sourceforge.net/p/pmw/bugs/39/
RESTRICT="test"

S="${WORKDIR}/${MY_P}"

python_test() {
	VIRTUALX_COMMAND="${PYTHON}"
	cd "${BUILD_DIR}/lib/Pmw/Pmw_${PV//./_}/" || die
	cp tests/{flagup.bmp,earthris.gif} . || die
	for test in tests/*_test.py; do
		echo "running test "$test
		PYTHONPATH=tests:../../ virtualmake $test || die
	done
}

python_install_all() {
	local DIR="Pmw/Pmw_${PV//./_}"

	use doc && HTML_DOCS=( "${DIR}"/doc/. )

	distutils-r1_python_install_all
}
