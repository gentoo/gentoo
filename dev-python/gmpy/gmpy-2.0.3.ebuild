# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/gmpy/gmpy-2.0.3.ebuild,v 1.11 2015/04/08 08:05:00 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3} )

inherit distutils-r1

MY_PN="${PN}2"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Python bindings for GMP, MPC, MPFR and MPIR libraries"
HOMEPAGE="http://code.google.com/p/gmpy/"
SRC_URI="http://gmpy.googlecode.com/files/${MY_P}.zip"

LICENSE="LGPL-2.1"
SLOT="2"
KEYWORDS="amd64 ~arm ia64 ppc ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="mpir"

RDEPEND="
	>=dev-libs/mpc-1.0.0
	>=dev-libs/mpfr-3.1.0
	!mpir? ( dev-libs/gmp )
	mpir? ( sci-libs/mpir )"
DEPEND="${RDEPEND}
	app-arch/unzip"

S="${WORKDIR}"/${MY_P}

python_configure_all() {
	mydistutilsargs=(
		$(usex mpir --mpir --gmp)
		)
}

python_test() {
	cd test || die
	${PYTHON} runtests.py || die
}
