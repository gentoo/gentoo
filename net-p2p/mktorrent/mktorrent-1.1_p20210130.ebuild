# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Simple command line utility to create BitTorrent metainfo files"
HOMEPAGE="https://github.com/pobrn/mktorrent"

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/pobrn/mktorrent"
else
	COMMIT_ID="de7d011b35458de1472665f50b96c9cf6c303f39"
	SRC_URI="https://github.com/pobrn/${PN}/archive/${COMMIT_ID}.tar.gz -> ${PN}-${COMMIT_ID}.tar.gz"
	S="${WORKDIR}/${PN}-${COMMIT_ID}"
fi

KEYWORDS="amd64 ~arm x86"
LICENSE="GPL-2+"
SLOT="0"
IUSE="threads +ssl debug"

RDEPEND="
	ssl? ( dev-libs/openssl:0= )
"

DEPEND="${RDEPEND}"

src_compile() {
	tc-export CC

	local myemakeargs=(
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
