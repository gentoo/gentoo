# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="Simple command line utility to create BitTorrent metainfo files"
HOMEPAGE="https://github.com/Rudde/mktorrent"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Rudde/mktorrent.git"
else
	SRC_URI="https://github.com/Rudde/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="threads +ssl debug"

RDEPEND="ssl? ( dev-libs/openssl:0= )"
DEPEND="${RDEPEND}"

src_compile() {
	tc-export CC

	emake \
		USE_LONG_OPTIONS=1 \
		USE_LARGE_FILES=1 \
		DEBUG=$(usex debug) \
		USE_OPENSSL=$(usex ssl) \
		USE_PTHREADS=$(usex threads)
}

src_install() {
	dobin ${PN}
	dodoc README
}
