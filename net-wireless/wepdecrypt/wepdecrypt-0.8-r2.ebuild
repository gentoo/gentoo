# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Enhanced version of WepAttack a tool for breaking 802.11 WEP keys"
HOMEPAGE="http://wepdecrypt.sourceforge.net/"
SRC_URI="mirror://sourceforge/wepdecrypt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="X"
RDEPEND="
	dev-libs/openssl:=
	net-libs/libpcap
	sys-libs/zlib
	X? ( x11-libs/fltk:1 )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-build.patch"
	"${FILESDIR}/${P}-fltk.patch"
	"${FILESDIR}/${P}-buffer.patch" # bug#340148.
	"${FILESDIR}/${P}-dyn.patch"
)

src_prepare() {
	default

	sed -i 's/make/$(MAKE)/g' Makefile || die "Sed failed"
}

src_configure() {
	econf \
		$(use X || echo --disable-gui)
}
