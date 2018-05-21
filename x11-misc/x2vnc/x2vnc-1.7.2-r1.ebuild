# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=0

inherit eutils

DESCRIPTION="Control a remote computer running VNC from X"
HOMEPAGE="http://fredrik.hubbe.net/x2vnc.html"
SRC_URI="http://fredrik.hubbe.net/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86"
IUSE="tk"

RDEPEND="x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXext
	x11-libs/libXinerama"
DEPEND="${RDEPEND}
	x11-base/xorg-proto
	tk? ( dev-tcltk/expect )"

src_unpack() {
		unpack ${A}
		cd "${S}/contrib"
		epatch "${FILESDIR}/expectk.patch"
}

src_install() {
	dodir /usr/share /usr/bin
	make DESTDIR="${D}" install || die
	use tk && dobin contrib/tkx2vnc
	dodoc ChangeLog README
}
