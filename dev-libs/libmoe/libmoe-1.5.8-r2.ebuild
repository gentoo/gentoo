# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libmoe/libmoe-1.5.8-r2.ebuild,v 1.7 2013/10/03 07:55:17 naota Exp $

inherit eutils multilib toolchain-funcs

DESCRIPTION="multi octet character encoding handling library"
HOMEPAGE="http://pub.ks-and-ks.ne.jp/prog/libmoe/"
SRC_URI="http://pub.ks-and-ks.ne.jp/prog/pub/${P}.tar.gz"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"
IUSE=""

DEPEND="dev-lang/perl"

src_unpack() {
	unpack ${A}
	cd "${S}"

	epatch "${FILESDIR}/${P}-gentoo.patch"
	epatch "${FILESDIR}/${P}-makefile.patch"

	sed -i \
		-e "/^PREFIX=/s:=.*:=/usr:" \
		-e "/^LIBSODIR=/s:=.*:=/usr/$(get_libdir):" \
		-e "/^MANDIR=/s:=.*:=/usr/share/man:" \
		-e "/^CF=/s:=:=${CFLAGS} :" \
		-e "/^LF=/s:=:=${LDFLAGS} :" \
		-e "s:=gcc:=$(tc-getCC):" \
		-e "/^AR=/s:=ar:=$(tc-getAR):" \
		Makefile || die
}

src_install() {
	emake DESTDIR="${D}" install || die

	dodoc ChangeLog
	dohtml libmoe.shtml
}
