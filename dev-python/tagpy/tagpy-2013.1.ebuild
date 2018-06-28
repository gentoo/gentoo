# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python{2_7,3_4,3_5,3_6} )

inherit distutils-r1

DESCRIPTION="Python Bindings for TagLib"
HOMEPAGE="https://mathema.tician.de//software/tagpy
	https://pypi.org/project/tagpy"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 ~sparc x86"
IUSE="examples"

RDEPEND=">=dev-libs/boost-1.49.0:=[python,threads,${PYTHON_USEDEP}]
	>=media-libs/taglib-1.7.2"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]"

DISTUTILS_IN_SOURCE_BUILD=1

python_configure() {
	"${PYTHON}" configure.py \
		--taglib-inc-dir="${EPREFIX}/usr/include/taglib" \
		--boost-python-libname="boost_python-${EPYTHON#python}"
}

python_install_all() {
	if use examples; then
		docinto examples
		dodoc -r test/*
	fi

	distutils-r1_python_install_all
}
