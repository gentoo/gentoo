# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Framebuffer screenshot utility"
HOMEPAGE="https://hem.bredband.net/gmogmo/fbgrab/"
SRC_URI="https://hem.bredband.net/gmogmo/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~ia64 ppc ~ppc64 ~sparc x86"
IUSE=""

RDEPEND="media-libs/libpng
	 sys-libs/zlib"

DEPEND="${RDEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${P}-zlib_h.patch" \
	       "${FILESDIR}/${P}-Makefile.patch"

		epatch_user
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}
	newman ${PN}.1.man ${PN}.1
}
