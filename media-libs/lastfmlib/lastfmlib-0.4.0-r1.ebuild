# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="C++ library to scrobble tracks on Last.fm"
HOMEPAGE="https://github.com/dirkvdb/lastfmlib/releases"
SRC_URI="https://github.com/dirkvdb/lastfmlib/archive/${P}.tar.gz"

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
