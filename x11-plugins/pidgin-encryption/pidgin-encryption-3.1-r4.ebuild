# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Pidgin IM Encryption PlugIn"
HOMEPAGE="https://pidgin-encrypt.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/pidgin-encrypt/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~riscv ~sparc ~x86"
IUSE="nls"

BDEPEND="virtual/pkgconfig"
RDEPEND="
	>=dev-libs/nss-3.11
	net-im/pidgin[gui]
	x11-libs/gtk+:2
"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-glib2.32.patch"
	"${FILESDIR}/${P}-time.patch"
	"${FILESDIR}/${P}-includes.patch"
)

src_configure() {
	econf $(use_enable nls)
}

src_install() {
	emake install DESTDIR="${ED}"
	dodoc CHANGELOG INSTALL NOTES README TODO VERSION WISHLIST

	find "${ED}" -type f -name "*.la" -delete || die
}
