# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/zmap/zmap-9999.ebuild,v 1.7 2015/01/05 12:52:32 jlec Exp $

EAPI=5

inherit cmake-utils fcaps git-r3

DESCRIPTION="Fast network scanner designed for Internet-wide network surveys"
HOMEPAGE="https://zmap.io/"
SRC_URI=""
EGIT_REPO_URI="git://github.com/zmap/zmap.git"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS=""
IUSE="json redis"

RDEPEND="
	dev-libs/gmp
	net-libs/libpcap
	json? ( dev-libs/json-c )
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
		$(cmake-utils_use_with json)
		$(cmake-utils_use_with redis)
		)
	cmake-utils_src_configure
}

FILECAPS=( cap_net_raw=ep usr/sbin/zmap )
