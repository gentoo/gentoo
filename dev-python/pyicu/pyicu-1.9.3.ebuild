# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python{2_7,3_3,3_4,3_5} )
DISTUTILS_IN_SOURCE_BUILD=1 # setup.py applies 2to3 to tests

inherit distutils-r1

MY_PN="PyICU"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python bindings for dev-libs/icu"
HOMEPAGE="https://github.com/ovalhub/pyicu"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc"

RDEPEND="${PYTHON_DEPS}
	dev-libs/icu
"
DEPEND="${RDEPEND}
	doc? ( dev-python/epydoc )"

S="${WORKDIR}/${MY_P}"

DOCS=(CHANGES CREDITS README.md)

python_compile_all() {
	if use doc; then
		einfo "Making documentation from ${EPYTHON} build"
		cd "${BEST_BUILD_DIR}" || die
		epydoc --html --verbose \
			--url="${HOMEPAGE}" --name="${MY_P}" \
			icu.py || die "Making the docs failed!"
	fi
}

python_test() {
	esetup.py test
}

python_install_all() {
	distutils-r1_python_install_all
	if use doc; then
		dohtml -r ../*/html/*
	fi
}
