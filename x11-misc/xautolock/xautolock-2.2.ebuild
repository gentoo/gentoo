# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/x11-misc/xautolock/xautolock-2.2.ebuild,v 1.11 2014/10/20 17:34:43 jer Exp $

EAPI=5
inherit toolchain-funcs

DESCRIPTION="An automatic X screen-locker/screen-saver"
SRC_URI="http://www.ibiblio.org/pub/Linux/X11/screensavers/${P}.tgz"
HOMEPAGE="http://www.ibiblio.org/pub/Linux/X11/screensavers/"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

RDEPEND="
	|| (
		x11-misc/alock
		x11-misc/i3lock
		x11-misc/slim
		x11-misc/slock
		x11-misc/xlockmore
		x11-misc/xtrlock
	)
	x11-libs/libXScrnSaver
"
DEPEND="
	${RDEPEND}
	app-text/rman
	x11-misc/imake
	x11-proto/scrnsaverproto
"

src_configure() {
	xmkmf || die
}

src_compile() {
	emake \
		CC="$(tc-getCC)" \
		CDEBUGFLAGS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}"
}

src_install () {
	dobin xautolock
	newman xautolock.man xautolock.1
	dodoc Changelog Readme Todo
}
