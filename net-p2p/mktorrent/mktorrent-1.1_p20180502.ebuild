# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit toolchain-funcs

DESCRIPTION="Simple command line utility to create BitTorrent metainfo files"
HOMEPAGE="https://github.com/Rudde/mktorrent"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Rudde/mktorrent.git"
else
	COMMIT_ID="96090fb175f3cef17ae2499e98c2868363106927"
	SRC_URI="https://github.com/Rudde/${PN}/archive/${COMMIT_ID}.tar.gz -> ${PN}-${COMMIT_ID}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
	S="${WORKDIR}/${PN}-${COMMIT_ID}"
fi

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="threads +ssl debug"

RDEPEND="ssl? ( dev-libs/openssl:0= )"
DEPEND="${RDEPEND}"

src_compile() {
	tc-export CC

	local myemakeargs=(
		USE_LONG_OPTIONS=1
		USE_LARGE_FILES=1
		DEBUG=$(usex debug)
		USE_OPENSSL=$(usex ssl)
		USE_PTHREADS=$(usex threads)
		)
	emake "${myemakeargs[@]}"
}

src_install() {
	dobin ${PN}
	dodoc README
}
