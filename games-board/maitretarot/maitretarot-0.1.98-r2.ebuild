# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

DESCRIPTION="Server for the french tarot game maitretarot"
HOMEPAGE="http://www.nongnu.org/maitretarot/"
SRC_URI="https://savannah.nongnu.org/download/maitretarot/${PN}.pkg/${PV}/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="virtual/pkgconfig"
DEPEND="dev-libs/glib:2
	dev-libs/libxml2
	dev-games/libmaitretarot"
RDEPEND="${DEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-format.patch
)

src_prepare() {
	default

	mv configure.{in,ac} || die

	# Remove bundled macros (avoid patching same file multiple times)
	rm -rf m4/{libmaitretarot,libmt_client}.m4 || die

	# Ensure we generate auto* with the fixed macros in tree
	# (not bundled)
	# bug #739142
	eautoreconf
}

src_configure() {
	econf --with-default-config-file="/etc/maitretarotrc.xml"
}
