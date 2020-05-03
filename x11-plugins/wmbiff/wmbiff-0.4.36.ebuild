# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="WMBiff is a dock applet for WindowMaker which can monitor up to 5 mailboxes"
HOMEPAGE="https://www.dockapps.net/wmbiff"
SRC_URI="https://www.dockapps.net/download/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="crypt"

RDEPEND="x11-libs/libX11
	x11-libs/libXext
	x11-libs/libXpm
	crypt? (
		>=dev-libs/libgcrypt-1.2.1:0
		>=net-libs/gnutls-2.2.0
		)"
DEPEND="${RDEPEND}
	x11-base/xorg-proto"
BDEPEND="virtual/pkgconfig"

DOCS="ChangeLog FAQ NEWS README TODO wmbiff/sample.wmbiffrc"
PATCHES=(
	"${FILESDIR}"/${PN}-0.4.27-invalid-strncpy.patch
	)

src_configure() {
	econf $(use_enable crypt crypto)
}
