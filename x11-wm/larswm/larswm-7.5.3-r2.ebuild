# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Tiling window manager for X11, based on 9wm by David Hogan"
HOMEPAGE="http://www.fnurt.net/larswm/"
SRC_URI="http://www.fnurt.net/larswm/${P}.tar.gz"
LICENSE="9wm"

SLOT="0"
KEYWORDS="alpha amd64 ppc ppc64 x86"

RDEPEND="x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	x11-misc/imake
	x11-misc/gccmakedep
	app-text/rman"

src_configure() {
	xmkmf -a || die
}

src_compile() {
	emake \
		CC=$(tc-getCC) \
		CCOPTIONS="${CFLAGS}" \
		EXTRA_LDOPTIONS="${LDFLAGS}"
}

src_install() {
	dobin larsclock larsmenu larsremote larswm
	newbin sample.xsession larswm-session
	local x
	for x in *.man; do
		newman ${x} ${x/man/1}
	done
	dodoc ChangeLog README* sample.*

	insinto /etc/X11
	newins sample.larswmrc larswmrc
	exeinto /etc/X11/Sessions
	newexe sample.xsession larswm
	insinto /usr/share/xsessions
	doins "${FILESDIR}"/larswm.desktop
}
