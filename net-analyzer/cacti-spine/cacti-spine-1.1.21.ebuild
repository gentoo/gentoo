# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit autotools eutils

MY_P=${PN}-${PV/_p/-}

DESCRIPTION="Spine is a fast poller for Cacti (formerly known as Cactid)"
HOMEPAGE="https://cacti.net/spine_info.php"
SRC_URI="https://www.cacti.net/downloads/spine/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 hppa ~ppc ~ppc64 ~sparc ~x86"

CDEPEND="
	dev-libs/openssl:*
	net-analyzer/net-snmp
	virtual/mysql
"
DEPEND="
	${CDEPEND}
	sys-apps/help2man
"
RDEPEND="
	${CDEPEND}
	>net-analyzer/cacti-0.8.8
"
PATCHES=(
	"${FILESDIR}"/${PN}-0.8.8d-ping.patch
	"${FILESDIR}"/${PN}-0.8.8g-net-snmp.patch
)

src_prepare() {
	default

	AT_M4DIR="config" eautoreconf
}

src_install() {
	dosbin spine
	insinto /etc/
	insopts -m0640 -o root
	newins spine.conf{.dist,}
	dodoc ChangeLog
}
