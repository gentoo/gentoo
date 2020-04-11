# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="A tool for recording Flash SWF movies from VNC sessions"
HOMEPAGE="https://www.unixuser.org/~euske/vnc2swf/"
SRC_URI="https://www.unixuser.org/~euske/vnc2swf/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="x11vnc"

RDEPEND="
	sys-libs/zlib
	x11-libs/libX11
	x11-libs/libXaw
	x11-libs/libXext
	x11-libs/libXmu
	x11-libs/libXt
	x11vnc? ( x11-misc/x11vnc )"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"

src_prepare() {
	default
	sed -i -e "s:docs:html:" README || die
	sed -i -e "s:-mouse ::" -e "s:./vnc2swf:vnc2swf:" recordwin.sh || die
}

src_install() {
	dobin vnc2swf
	if use x11vnc; then
		# this USE flag is needed because recordwin
		# only works on x11vnc
		newbin recordwin.sh recordwin
	fi
	insinto /etc/X11/app-defaults
	newins Vnc2Swf.ad Vnc2Swf
	dodoc README*

	docinto html
	dodoc docs/*.{html,swf}
}
