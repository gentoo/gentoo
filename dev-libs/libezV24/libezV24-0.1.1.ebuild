# Copyright 1999-2008 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libezV24/libezV24-0.1.1.ebuild,v 1.10 2008/01/15 09:01:17 drac Exp $

inherit eutils multilib toolchain-funcs

DESCRIPTION="library that provides an easy API to Linux serial ports"
HOMEPAGE="http://ezv24.sourceforge.net"
SRC_URI="mirror://sourceforge/ezv24/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE=""

RDEPEND=""
DEPEND=""

src_unpack() {
	unpack ${A}
	cd "${S}"
	epatch "${FILESDIR}"/${P}-build.patch
	epatch "${FILESDIR}"/${P}-test.patch
	sed -i -e 's:__LINUX__:__linux__:' *.c *.h
}

src_compile() {
	tc-export AR CC RANLIB
	emake || die "emake failed."
}

src_install() {
	export NO_LDCONFIG="stupid"
	emake DESTDIR="${D}" LIBDIR="/usr/$(get_libdir)" \
		install || die "emake install failed."
	dodoc AUTHORS BUGS ChangeLog HISTORY README
	dohtml api-html/*
}
