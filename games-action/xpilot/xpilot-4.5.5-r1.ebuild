# Copyright 1999-2021 Gentoo Authors
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
	>=x11-misc/imake-1.0.8-r1"

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

src_configure() {
	CC="$(tc-getBUILD_CC)" LD="$(tc-getLD)" \
		IMAKECPP="${IMAKECPP:-$(tc-getCPP)}" xmkmf -a || die
}

src_compile() {
	emake \
		AR="$(tc-getAR) cq" \
		CC="$(tc-getCC)" \
		RANLIB="$(tc-getRANLIB)" \
		CDEBUGFLAGS="${CFLAGS}" \
		LOCAL_LDFLAGS="${LDFLAGS}"
}

src_install() {
	emake DESTDIR="${D}" install
	emake DESTDIR="${D}" install.man
	newicon lib/textures/logo.ppm ${PN}.ppm
	make_desktop_entry ${PN} XPilot /usr/share/pixmaps/${PN}.ppm
	dodoc README.txt doc/{ChangeLog,CREDITS,FAQ,README*,TODO}
}
