# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Loki Software binary patch tool"
HOMEPAGE="https://github.com/icculus/loki_patch"
SRC_URI="
	mirror://gentoo/${P}.tar.bz2
	mirror://gentoo/loki_setupdb-${PV}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-util/xdelta:0
	dev-libs/libxml2
	dev-libs/glib:2"
DEPEND="${RDEPEND}"
BDEPEND="virtual/pkgconfig"

S="${WORKDIR}"

PATCHES=(
	"${FILESDIR}"/${P}-build.patch
	"${FILESDIR}"/${P}-patchdata.patch
	"${FILESDIR}"/${P}-xdelta-gzip.patch
)

src_prepare() {
	default

	cd loki_setupdb || die
	mv configure.{in,ac} || die
	eautoreconf

	cd "${S}"/${PN} || die
	mv configure.{in,ac} || die
	eautoreconf
}

src_configure() {
	cd loki_setupdb || die
	econf
	cd "${S}"/${PN} || die
	econf
}

src_compile() {
	emake -C loki_setupdb
	emake -C loki_patch
}

src_install() {
	cd ${PN} || die
	dobin loki_patch make_patch
	dodoc CHANGES NOTES README TODO
}
