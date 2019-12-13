# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Genetic Algorithm Utility Library"
HOMEPAGE="http://GAUL.sourceforge.net/"
SRC_URI="mirror://sourceforge/gaul/${P}-0.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="slang"

RDEPEND="slang? ( sys-libs/slang:= )"
DEPEND="${RDEPEND}"

S="${WORKDIR}/${P}-0"

PATCHES=(
	"${FILESDIR}"/${P}-slang2-error.patch
	"${FILESDIR}"/${P}-as-needed.patch
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
	find "${D}" -name '*.la' -delete || die
}
