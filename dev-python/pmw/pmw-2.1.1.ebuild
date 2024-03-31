# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYPI_PN=${PN^}
PYTHON_COMPAT=( python3_{10..12} )
PYTHON_REQ_USE="tk"

inherit distutils-r1 virtualx pypi

DESCRIPTION="Toolkit for building high-level compound Python widgets using the Tkinter module"
HOMEPAGE="https://pypi.org/project/Pmw/"

LICENSE="BSD"
SLOT="py3"
KEYWORDS="~alpha ~amd64 ~ia64 ~ppc ~sparc ~x86 ~amd64-linux ~x86-linux ~x64-macos"
IUSE="doc test"
# https://sourceforge.net/p/pmw/bugs/39/
RESTRICT="test"

DEPEND="!dev-python/pmw:0"
RDEPEND="${DEPEND}"

python_test() {
	VIRTUALX_COMMAND="${PYTHON}"
	cd "${BUILD_DIR}/lib/Pmw/Pmw_${PV//./_}/" || die
	cp tests/{flagup.bmp,earthris.gif} . || die
	for test in tests/*_test.py; do
		echo "running test "$test
		PYTHONPATH=tests:../../ virtx emake -j1 $test || die
	done
}

python_install_all() {
	local DIR="Pmw/Pmw_${PV//./_}"

	use doc && HTML_DOCS=( "${DIR}"/doc/. )

	distutils-r1_python_install_all
}
