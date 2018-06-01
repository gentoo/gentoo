# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils toolchain-funcs

DESCRIPTION="Framebuffer screenshot utility"
HOMEPAGE="https://fbgrab.monells.se/"
SRC_URI="https://fbgrab.monells.se/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 arm ~arm64 ~ia64 ppc ~ppc64 ~s390 ~sparc x86"
IUSE=""

RDEPEND="media-libs/libpng:=
	 sys-libs/zlib"

DEPEND="${RDEPEND}"

src_prepare() {
	sed -i -e "s:-g::" Makefile || die "sed failed"
}

src_compile() {
	emake CC="$(tc-getCC)"
}

src_install() {
	dobin ${PN}
	newman ${PN}.1.man ${PN}.1
}
