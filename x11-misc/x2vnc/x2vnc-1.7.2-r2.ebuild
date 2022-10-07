# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Control a remote computer running VNC from X"
HOMEPAGE="https://fredrik.hubbe.net/x2vnc.html"
SRC_URI="https://fredrik.hubbe.net/x2vnc/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~alpha amd64 ppc sparc x86"
IUSE="tk"

COMMON_DEPEND="
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXext
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/libXxf86dga"
RDEPEND="
	${COMMON_DEPEND}
	tk? ( dev-tcltk/expect )"
DEPEND="
	${COMMON_DEPEND}
	x11-base/xorg-proto"

PATCHES=(
	"${FILESDIR}"/expectk.patch
	"${FILESDIR}"/${P}-clang16.patch
)

src_install() {
	dodir /usr/share /usr/bin
	emake DESTDIR="${D}" install
	use tk && dobin contrib/tkx2vnc
	dodoc ChangeLog README
}
