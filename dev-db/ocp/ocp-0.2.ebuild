# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Oracle copy tool"
HOMEPAGE="https://github.com/maxsatula/ocp"

if [[ ${PV} == *9999 ]] ; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/maxsatula/ocp.git"
	EGIT_BRANCH="develop"
	inherit git-r3 autotools
else
	SRC_URI="https://github.com/maxsatula/ocp/releases/download/v${PV}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-2"
SLOT="0"
IUSE=""

DEPEND="sys-libs/zlib
	dev-libs/popt
	dev-db/oracle-instantclient-basic"
RDEPEND="${DEPEND}"

inherit flag-o-matic

pkg_setup() {
	append-ldflags $(no-as-needed)
}

src_prepare() {
	if [[ ${PV} == *9999 ]] ; then
		eautoreconf
	fi
	eapply_user
}
