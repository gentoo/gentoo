# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils toolchain-funcs fortran-2

DESCRIPTION="High quality system independent, open source libm"
HOMEPAGE="https://github.com/JuliaLang/openlibm"
SRC_URI="https://github.com/JuliaLang/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT freedist public-domain BSD"
SLOT="0/0.1.0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

IUSE="static-libs"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-respect-toolchain.patch
}

src_compile() {
	tc-export CC
	tc-export AR
	emake libopenlibm.so
	use static-libs && emake libopenlibm.a
}

src_test() {
	emake
}

src_install() {
	dolib.so libopenlibm.so*
	use static-libs && dolib.a libopenlibm.a
	doheader include/{cdefs,types}-compat.h src/openlibm.h
	dodoc README.md
}
