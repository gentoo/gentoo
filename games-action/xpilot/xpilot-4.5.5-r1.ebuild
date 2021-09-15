# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit desktop toolchain-funcs

DESCRIPTION="Multi-player 2D client/server space game"
HOMEPAGE="http://www.xpilot.org/"
SRC_URI="
	https://dev.gentoo.org/~ionen/distfiles/${PN}.png
	mirror://sourceforge/xpilotgame/${P}.tar.bz2"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	x11-libs/libX11
	x11-libs/libXext"
DEPEND="
	${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="
	app-text/rman
	x11-misc/gccmakedep
	>=x11-misc/imake-1.0.8-r1"

DOCS=(
	README.txt
	doc/{ChangeLog,CREDITS,FAQ,TODO}
	doc/README.{MAPS,MAPS2,SHIPS,sounds,talkmacros}
)

src_prepare() {
	default

	sed -i \
		-e "/^INSTMAN/s|=.*|=${EPREFIX}/usr/share/man/man6|" \
		-e "/^INSTLIB/s|=.*|=${EPREFIX}/usr/share/${PN}|" \
		-e "/^INSTBIN/s|=.*|=${EPREFIX}/usr/bin|" \
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
	default
	emake DESTDIR="${D}" install.man

	doicon "${DISTDIR}"/${PN}.png
	make_desktop_entry ${PN} XPilot
}
