# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit desktop toolchain-funcs

DESCRIPTION="A multi-player 2D client/server space game"
HOMEPAGE="http://www.xpilot.org/"
SRC_URI="mirror://sourceforge/xpilotgame/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXext"
DEPEND="${RDEPEND}
	app-text/rman
	x11-base/xorg-proto
	x11-misc/gccmakedep
	x11-misc/imake"

src_prepare() {
	#default
	eapply_user

	sed -i \
		-e '/^INSTMAN/s:=.*:=/usr/share/man/man6:' \
		-e "/^INSTLIB/s:=.*:=/usr/share/${PN}:" \
		-e "/^INSTBIN/s:=.*:=/usr/bin:" \
		Local.config || die

	# work with glibc-2.20
	sed -i \
		-e 's/getline/lgetline/' \
		src/client/textinterface.c || die
}

src_compile() {
	xmkmf || die
	emake Makefiles
	emake includes
	emake depend
	emake CC="$(tc-getCC)" CDEBUGFLAGS="${CFLAGS} ${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" install
	emake DESTDIR="${D}" install.man
	newicon lib/textures/logo.ppm ${PN}.ppm
	make_desktop_entry ${PN} XPilot /usr/share/pixmaps/${PN}.ppm
	dodoc README.txt doc/{ChangeLog,CREDITS,FAQ,README*,TODO}
}
