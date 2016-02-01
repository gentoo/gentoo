# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils multilib

DESCRIPTION="X11-based passphrase dialog for use with OpenSSH"
HOMEPAGE="http://www.liquidmeme.net/software/x11-ssh-askpass/"
SRC_URI="http://www.liquidmeme.net/software/x11-ssh-askpass/${P}.tar.gz"

LICENSE="HPND"
SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE=""

RDEPEND="virtual/ssh
	x11-libs/libXt
	x11-libs/libX11
	x11-libs/libSM
	x11-libs/libICE"

DEPEND="${RDEPEND}
	>=x11-misc/imake-1.0.7
	app-text/rman"

src_compile() {
	econf --libexecdir=/usr/$(get_libdir)/misc || die
	xmkmf || die
	make includes || die
	make "CDEBUGFLAGS=${CFLAGS}" || die
}

src_install() {
	newman x11-ssh-askpass.man x11-ssh-askpass.1
	dobin x11-ssh-askpass
	dodir /usr/$(get_libdir)/misc
	dosym /usr/bin/x11-ssh-askpass /usr/$(get_libdir)/misc/ssh-askpass
	dodoc ChangeLog README TODO
}
