# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit autotools

MY_P=${PN}-${PV/_p/-}

DESCRIPTION="Spine is a fast poller for Cacti (formerly known as Cactid)"
HOMEPAGE="https://cacti.net/spine_info.php"
SRC_URI="https://www.cacti.net/downloads/spine/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ppc ~ppc64 sparc x86"
IUSE="libressl"

BDEPEND="sys-apps/help2man"
DEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	net-analyzer/net-snmp:=
	dev-db/mysql-connector-c:0=
"
RDEPEND="
	${DEPEND}
	>net-analyzer/cacti-0.8.8
"

PATCHES=(
	"${FILESDIR}"/${PN}-0.8.8g-net-snmp.patch
)

src_prepare() {
	default
	eautoreconf
}

src_install() {
	dosbin spine

	insinto /etc/
	insopts -m0640 -o root
	newins spine.conf{.dist,}

	doman spine.1
	dodoc CHANGELOG
}
