# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

GH_TS="1668377184" # https://bugs.gentoo.org/881037 - bump this UNIX timestamp if the downloaded file changes checksum

DESCRIPTION="C++ library to scrobble tracks on Last.fm"
HOMEPAGE="https://github.com/dirkvdb/lastfmlib/releases"
SRC_URI="https://github.com/dirkvdb/lastfmlib/archive/${P}.tar.gz
 -> ${P}.gh@${GH_TS}.tar.gz
"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="amd64 ~ppc x86"
IUSE="debug syslog"

BDEPEND="virtual/pkgconfig"
RDEPEND="net-misc/curl"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}/${P}-string-conv.patch"
)

S="${WORKDIR}/${PN}-${P}"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		--disable-static \
		$(use_enable debug) \
		$(use_enable syslog logging) \
		--disable-unittests
}

src_install() {
	default
	find "${D}"/usr -name '*.la' -delete || die "Pruning failed"
}
