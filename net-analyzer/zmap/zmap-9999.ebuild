# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake fcaps git-r3

DESCRIPTION="Fast network scanner designed for Internet-wide network surveys"
HOMEPAGE="https://zmap.io/"
EGIT_REPO_URI="https://github.com/zmap/zmap.git"

LICENSE="Apache-2.0"
SLOT="0"
IUSE="redis"

RDEPEND="
	dev-libs/gmp:=
	net-libs/libpcap
	dev-libs/json-c:=
	redis? ( dev-libs/hiredis:= )"
DEPEND="${RDEPEND}
	dev-util/gengetopt
	sys-devel/flex
	dev-util/byacc
"

src_configure() {
	local mycmakeargs=(
		-DENABLE_DEVELOPMENT=OFF
		-DWITH_WERROR=OFF
		-DWITH_REDIS="$(usex redis)"
		)
	cmake_src_configure
}

FILECAPS=( cap_net_raw=ep usr/sbin/zmap )
