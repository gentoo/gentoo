# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
inherit toolchain-funcs

#Note: there's no difference vs 2.0-12
MY_P=${P/-/_}

DESCRIPTION="A simplistic screen locking program for X"
SRC_URI="mirror://debian/pool/main/x/xtrlock/${MY_P}.tar.gz"
HOMEPAGE="http://ftp.debian.org/debian/pool/main/x/xtrlock/"

SLOT="0"
LICENSE="GPL-3"
KEYWORDS="amd64 ppc x86"
IUSE=""

RDEPEND="x11-libs/libX11"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-misc/imake"

src_prepare() {
	sed -i -e 's|".*"|"'"${PV}"'"|g' patchlevel.h || die
}

src_compile() {
	xmkmf || die
	emake CDEBUGFLAGS="${CFLAGS} -DSHADOW_PWD" CC="$(tc-getCC)" \
		EXTRA_LDOPTIONS="${LDFLAGS}" xtrlock
}

src_install() {
	dobin xtrlock
	chmod u+s "${D}"/usr/bin/xtrlock
	newman xtrlock.man xtrlock.1
	dodoc debian/changelog
}
