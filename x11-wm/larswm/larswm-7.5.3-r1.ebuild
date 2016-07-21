# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="2"

inherit toolchain-funcs

DESCRIPTION="Tiling window manager for X11, based on 9wm by David Hogan"
HOMEPAGE="http://larswm.fnurt.net/"
SRC_URI="http://larswm.fnurt.net/${P}.tar.gz"
LICENSE="9wm"

SLOT="0"
KEYWORDS="alpha ~amd64 ppc ppc64 x86 ~x86-fbsd"
IUSE=""

RDEPEND="x11-libs/libX11
	x11-libs/libXmu
	x11-libs/libXt
	x11-libs/libXext"
DEPEND="${RDEPEND}
	x11-proto/xproto
	x11-proto/xextproto
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
		EXTRA_LDOPTIONS="${LDFLAGS}" \
		|| die
}

src_install() {
	dobin larsclock larsmenu larsremote larswm
	newbin sample.xsession larswm-session
	for x in *.man ; do
		newman $x ${x/man/1}
	done
	dodoc ChangeLog README* sample.*

	insinto /etc/X11
	newins sample.larswmrc larswmrc || die
	exeinto /etc/X11/Sessions
	newexe sample.xsession larswm
	insinto /usr/share/xsessions
	doins "${FILESDIR}"/larswm.desktop || die
}
