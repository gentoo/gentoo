# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Simple command line utility to create BitTorrent metainfo files"
HOMEPAGE="https://github.com/Rudde/mktorrent"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/Rudde/mktorrent.git"
else
	COMMIT_ID="4c221a05d949a3767a2671de139c6014909daf6b"
	SRC_URI="https://github.com/Rudde/${PN}/archive/${COMMIT_ID}.tar.gz -> ${PN}-${COMMIT_ID}.tar.gz"
	KEYWORDS="~amd64 ~arm ~x86"
	S="${WORKDIR}/${PN}-${COMMIT_ID}"
fi

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"
IUSE="threads +ssl libressl debug"

RDEPEND="
	ssl? (
		!libressl? ( dev-libs/openssl:0= )
		libressl? ( dev-libs/libressl:0= )
	)
"

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
