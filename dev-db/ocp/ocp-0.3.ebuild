# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Oracle copy tool"
HOMEPAGE="https://github.com/maxsatula/ocp"

inherit toolchain-funcs

if [[ ${PV} == *9999 ]]; then
	EGIT_REPO_URI="https://github.com/maxsatula/ocp.git"
	EGIT_BRANCH="develop"
	inherit autotools git-r3
else
	SRC_URI="https://github.com/maxsatula/ocp/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

RDEPEND="
	dev-db/oracle-instantclient
	dev-libs/popt
	sys-libs/zlib"
DEPEND="
	dev-db/oracle-instantclient[sdk]
	${RDEPEND}"

src_compile() {
	emake AR="$(tc-getAR)"
}

src_prepare() {
	default

	if [[ ${PV} == *9999 ]] ; then
		eautoreconf
	fi
}
