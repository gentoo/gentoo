# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-analyzer/zmap/zmap-1.1.1.ebuild,v 1.2 2013/12/30 09:58:06 jlec Exp $

EAPI=5

inherit cmake-utils fcaps

DESCRIPTION="Fast network scanner designed for Internet-wide network surveys"
HOMEPAGE="https://zmap.io/"
SRC_URI="https://github.com/${PN}/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS=" ~amd64 ~x86"
IUSE="json redis"

RDEPEND="
	dev-libs/gmp
	net-libs/libpcap
	json? ( dev-libs/json-c )
	redis? ( dev-libs/hiredis )"
DEPEND="${RDEPEND}
	dev-util/gengetopt
	sys-devel/flex
	dev-util/byacc"

PATCHES=(
	"${FILESDIR}"/${P}-out-of-src.patch
	"${FILESDIR}"/${P}-json-c.patch
)

src_configure() {
	local mycmakeargs=(
		-DENABLE_DEVELOPMENT=OFF
		-DENABLE_HARDENING=OFF
		$(cmake-utils_use_with json)
		$(cmake-utils_use_with redis)
		)
	cmake-utils_src_configure
}

FILECAPS=( cap_net_raw=ep usr/sbin/zmap )
