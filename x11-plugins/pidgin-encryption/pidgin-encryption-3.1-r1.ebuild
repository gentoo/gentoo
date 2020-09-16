# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit flag-o-matic

DESCRIPTION="Pidgin IM Encryption PlugIn"
HOMEPAGE="http://pidgin-encrypt.sourceforge.net/"
SRC_URI="mirror://sourceforge/pidgin-encrypt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 sparc x86"
IUSE="nls"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	>=dev-libs/nss-3.11
	net-im/pidgin[gtk]
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-glib2.32.patch"
)

src_configure() {
	strip-flags
	replace-flags -O? -O2
	econf $(use_enable nls) --disable-static
}

src_install() {
	emake install DESTDIR="${ED}"
	dodoc CHANGELOG INSTALL NOTES README TODO VERSION WISHLIST
}
