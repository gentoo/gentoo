# Copyright 2003-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Command-line WebDAV client"
HOMEPAGE="https://notroj.github.io/cadaver/ https://github.com/notroj/cadaver"
SRC_URI="https://notroj.github.io/cadaver/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~ppc64 ~sparc ~x86"
IUSE="nls"

DEPEND=">=net-libs/neon-0.34.0:="
RDEPEND="${DEPEND}"
BDEPEND="sys-devel/gettext"

DOCS=( BUGS ChangeLog FAQ NEWS README.md THANKS TODO )

PATCHES=(
	"${FILESDIR}"/${PN}-0.23.2-disable-nls.patch
)

src_prepare() {
	default

	rm -r lib/expat || die "rm failed"
}

src_configure() {
	econf \
		$(use_enable nls)
}
