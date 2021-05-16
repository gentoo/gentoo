# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/juhovh/${PN}.git"
else
	EGIT_COMMIT="096b61ad14c90169f438e690d096e3fcf87e504e"
	SRC_URI="https://github.com/juhovh/${PN}/archive/${EGIT_COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-${EGIT_COMMIT}"
	KEYWORDS="~amd64 ~arm arm64 ~x86"
fi

DESCRIPTION="Apple airplay and raop protocol server"
HOMEPAGE="https://github.com/juhovh/shairplay"
LICENSE="BSD LGPL-2.1 MIT
	playfair? ( GPL-3+ )"

SLOT="0"
IUSE="+playfair static-libs"

DEPEND="
	net-dns/avahi[mdnsresponder-compat]
	media-libs/libao
"

RDEPEND="
	${DEPEND}
"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf \
		$(use_with playfair) \
		$(use_enable static-libs static)
}

src_install() {
	default
	find "${D}" -name '*.la' -delete || die
}
