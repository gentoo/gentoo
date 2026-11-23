# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

inherit autotools

DESCRIPTION="Genetic Algorithm Utility Library"
HOMEPAGE="https://gaul.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/gaul/${P}-0.tar.gz"

S="${WORKDIR}/${P}-0"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="slang"

RDEPEND="slang? ( sys-libs/slang:= )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${PN}-0.1849-slang2-error.patch
	"${FILESDIR}"/${PN}-0.1849-as-needed.patch
)

src_prepare() {
	default
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable slang)
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
