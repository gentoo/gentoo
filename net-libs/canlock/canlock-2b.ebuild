# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/canlock/canlock-2b.ebuild,v 1.7 2013/07/11 19:03:44 vincent Exp $

EAPI=4

inherit eutils multilib toolchain-funcs

MY_P="${P/-/_}"
DESCRIPTION="A library for creating and verifying Usenet cancel locks"
HOMEPAGE="http://packages.qa.debian.org/c/canlock.html"
SRC_URI="mirror://debian/pool/main/c/${PN}/${MY_P}.orig.tar.gz
	mirror://debian/pool/main/c/${PN}/${MY_P}-6.diff.gz"

LICENSE="BSD MIT"
SLOT="0"
KEYWORDS="amd64 ppc x86 ~amd64-linux ~x86-linux"
IUSE="static-libs"

S=${WORKDIR}/${P/-/}

src_prepare() {
	epatch "${WORKDIR}"/${MY_P}-6.diff \
		"${FILESDIR}"/${P}-make.patch
}

src_compile() {
	local targets="shared"
	if use static-libs || use test ; then
		targets+=" static"
	fi

	emake CC="$(tc-getCC)" AR="$(tc-getAR)" RANLIB="$(tc-getRANLIB)" ${targets}
}

src_install() {
	use static-libs && dolib.a src/libcanlock.a
	dolib.so src/libcanlock.so.2.0.0
	dosym libcanlock.so.2.0.0 /usr/$(get_libdir)/libcanlock.so.2
	dosym libcanlock.so.2.0.0 /usr/$(get_libdir)/libcanlock.so
	insinto /usr/include
	doins include/canlock.h
	dodoc CHANGES README doc/HOWTO
}
