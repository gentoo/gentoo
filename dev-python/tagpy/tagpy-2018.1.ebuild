# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7} )
inherit distutils-r1

DESCRIPTION="Python Bindings for TagLib"
HOMEPAGE="https://mathema.tician.de//software/tagpy
	https://pypi.org/project/tagpy/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86"
IUSE="examples"

RDEPEND="
	dev-libs/boost:=[python,threads,${PYTHON_USEDEP}]
	>=media-libs/taglib-1.8
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"

DISTUTILS_IN_SOURCE_BUILD=1

PATCHES=( "${FILESDIR}/${P}-taglib-1.8.patch" )

python_prepare_all() {
	cp "${FILESDIR}"/${P}-readme.rst README.rst || die
	distutils-r1_python_prepare_all
}

python_configure() {
	local boostpy_ver="${EPYTHON#python}"
	if has_version ">=dev-libs/boost-1.70"; then
		boostpy_ver="${boostpy_ver/\.}"
	else
		boostpy_ver="-${boostpy_ver}"
	fi

	"${PYTHON}" configure.py \
		--taglib-inc-dir="${EPREFIX}/usr/include/taglib" \
		--boost-python-libname="boost_python${boostpy_ver}"
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r test/*
	fi

	distutils-r1_python_install_all
}
