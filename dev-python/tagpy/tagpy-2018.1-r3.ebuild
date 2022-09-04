# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_IN_SOURCE_BUILD=1
inherit edo distutils-r1

DESCRIPTION="Python Bindings for TagLib"
HOMEPAGE="
	https://mathema.tician.de//software/tagpy
	https://pypi.org/project/tagpy/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86"
IUSE="examples"

RDEPEND="
	dev-libs/boost:=[python,${PYTHON_USEDEP}]
	>=media-libs/taglib-1.8"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}"/${P}-taglib-1.8.patch )

distutils_enable_tests pytest

python_prepare_all() {
	cp "${FILESDIR}"/${P}-readme.rst README.rst || die
	distutils-r1_python_prepare_all
}

python_configure() {
	local boostpy_ver="${EPYTHON#python}"

	edo "${EPYTHON}" configure.py \
		--taglib-inc-dir="${ESYSROOT}"/usr/include/taglib \
		--boost-python-libname="boost_python${boostpy_ver/\.}"
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r test/.
	fi

	distutils-r1_python_install_all
}
