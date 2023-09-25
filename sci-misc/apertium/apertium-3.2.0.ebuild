# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Shallow-transfer machine Translation engine and toolbox"
HOMEPAGE="https://apertium.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-libs/libxslt
	dev-libs/libpcre[cxx]
	>=sci-misc/lttoolbox-3.2
	virtual/libiconv"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}"/${PV}-flags.patch
	"${FILESDIR}"/${PV}-datadir.patch
	"${FILESDIR}"/${P}-libpcre.patch
	"${FILESDIR}"/${P}-autotools.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_compile() {
	emake -j1
}

src_install() {
	default

	# no static archives
	find "${ED}" -name '*.la' -delete || die
}
