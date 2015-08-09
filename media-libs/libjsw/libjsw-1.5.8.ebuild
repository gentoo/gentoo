# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit eutils multilib

DESCRIPTION="provide a uniform API and user configuration for joysticks and game controllers"
HOMEPAGE="http://freshmeat.net/projects/libjsw/"
SRC_URI="http://wolfsinger.com/~wolfpack/packages/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE=""

DEPEND=""

src_prepare() {
	cp include/jsw.h libjsw/
	epatch "${FILESDIR}"/${P}-build.patch
	bunzip2 libjsw/man/* || die
}

src_compile() {
	LDFLAGS+=" -Wl,-soname,libjsw.so.1"
	cd libjsw
	emake
	ln -s libjsw.so.${PV} libjsw.so
}

src_install() {
	insinto /usr/include
	doins include/jsw.h

	dodoc README
	docinto jswdemos
	dodoc jswdemos/*

	cd "${S}"/libjsw
	dolib.so libjsw.so.${PV}
	dosym libjsw.so.${PV} /usr/$(get_libdir)/libjsw.so
	dosym libjsw.so.${PV} /usr/$(get_libdir)/libjsw.so.1
	doman man/*
}
