# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit cmake-utils fcaps git-r3

DESCRIPTION="Fast network scanner designed for Internet-wide network surveys"
HOMEPAGE="https://zmap.io/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/zmap/zmap.git"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS=""
IUSE="mongo redis"

RDEPEND="
	dev-libs/gmp:0
	net-libs/libpcap
	dev-libs/json-c
	mongo? ( dev-db/mongo )
	redis? ( dev-libs/hiredis )"
DEPEND="${RDEPEND}
	dev-util/gengetopt
	sys-devel/flex
	dev-util/byacc
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_DEVELOPMENT=OFF
		-DENABLE_HARDENING=OFF
		-DWITH_WERROR=OFF
		-DWITH_mongo="$(usex mongo)"
		-DWITH_redis="$(usex redis)"
		)
	cmake-utils_src_configure
}

FILECAPS=( cap_net_raw=ep usr/sbin/zmap )
