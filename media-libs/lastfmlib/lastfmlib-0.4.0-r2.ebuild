# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="C++ library to scrobble tracks on Last.fm"
HOMEPAGE="https://github.com/dirkvdb/lastfmlib/releases"
SRC_URI="https://github.com/dirkvdb/lastfmlib/archive/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="debug syslog test"
RESTRICT="!test? ( test )"

RDEPEND="net-misc/curl"
DEPEND="
	${RDEPEND}
	test? ( dev-cpp/gtest )
"
BDEPEND="virtual/pkgconfig"

PATCHES=(
	"${FILESDIR}/${P}-string-conv.patch"
	"${FILESDIR}/${PN}-0.4.0-autotools-tests.patch"
	"${FILESDIR}/${PN}-0.4.0-out-of-bounds-trim.patch"
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	CONFIG_SHELL="${BROOT}"/bin/bash econf \
		$(use_enable debug) \
		$(use_enable syslog logging) \
		$(use_enable test unittests)
}

src_test() {
	emake check VERBOSE=1
}

src_install() {
	default
	find "${D}"/usr -name '*.la' -delete || die "Pruning failed"
}
