# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit toolchain-funcs eutils

S=${WORKDIR}/DND/DNDlib
DESCRIPTION="OffiX' Drag'n'drop library"
HOMEPAGE="http://leb.net/offix"
SRC_URI="http://leb.net/offix/${PN}.${PV}.tgz"
IUSE=""
SLOT="0"
LICENSE="GPL-2 LGPL-2"
KEYWORDS="alpha amd64 hppa ia64 ppc ppc64 sparc x86"

RDEPEND=">=x11-libs/libX11-1.0.0
	>=x11-libs/libXmu-1.0.0
	>=x11-libs/libXt-1.0.0
	>=x11-libs/libICE-1.0.0
	>=x11-libs/libSM-1.0.0
	>=x11-libs/libXaw-1.0.1
	>=x11-proto/xproto-7.0.4"
DEPEND="${RDEPEND}"

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-gentoo.diff || die
	epatch "${FILESDIR}"/Makefile-fix.patch || die
}

src_compile() {
	tc-export CC CXX RANLIB AR
	econf --with-x || die
	emake || die
}

src_install () {
	make DESTDIR="${D}" install || die
}
