# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

inherit eutils

DESCRIPTION="A tool for recording Flash SWF movies from VNC sessions"
HOMEPAGE="http://www.unixuser.org/~euske/vnc2swf"
SRC_URI="http://www.unixuser.org/~euske/vnc2swf/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="x11vnc"

RDEPEND="x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXt"
DEPEND="${RDEPEND}
	x11-proto/xextproto
	x11-proto/xproto
	sys-apps/sed
	sys-libs/zlib
	x11vnc? ( x11-misc/x11vnc )"

src_unpack() {
	unpack ${A}
	cd "${S}"
	sed -ie "s:docs:html:" README || die
	sed -ie "s:-mouse ::" recordwin.sh || die
}

src_install() {
	dobin vnc2swf || die
	if use x11vnc; then
		# this USE flag is needed because recordwin
		# only works on x11vnc
		newbin recordwin.sh recordwin
		dosed "s:./vnc2swf:vnc2swf:" /usr/bin/recordwin || die
	fi
	insinto /etc/X11/app-defaults
	newins Vnc2Swf.ad Vnc2Swf || die
	dodoc README*  || die
	dohtml -a html,swf docs/* || die
}
