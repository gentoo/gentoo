# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

AUTOTOOLS_AUTORECONF=true

inherit autotools-utils fortran-2 toolchain-funcs versionator

MY_PV="$(replace_all_version_separators -)"

DESCRIPTION="Matrix elements (integrals) evaluation over Cartesian Gaussian functions"
HOMEPAGE="https://github.com/evaleev/libint"
SRC_URI="https://github.com/evaleev/libint/archive/release-${MY_PV}.tar.gz -> ${P}.tar.gz"

SLOT="1"
LICENSE="GPL-2"
KEYWORDS="amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

S="${WORKDIR}/${PN}-release-${MY_PV}"

PATCHES=( "${FILESDIR}"/${P}-as-needed.patch )

src_prepare() {
	mv configure.{in,ac} || die
	autotools-utils_src_prepare
}

src_configure() {
	local myeconfargs=(
		--enable-deriv
		--enable-r12
		--with-cc=$(tc-getCC)
		--with-cxx=$(tc-getCXX)
		--with-cc-optflags="${CFLAGS}"
		--with-cxx-optflags="${CXXFLAGS}"
	)
	autotools-utils_src_configure
}
