# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools git-r3

MY_P=${PN}-${PV/_p/-}

DESCRIPTION="Spine is a fast poller for Cacti (formerly known as Cactid)"
HOMEPAGE="https://cacti.net/spine_info.php"
EGIT_REPO_URI="https://github.com/Cacti/spine"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS=""
IUSE="libressl"

CDEPEND="
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	net-analyzer/net-snmp:=
	dev-db/mysql-connector-c:0=
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
