# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

MY_P=${PN}-${PV/_p/-}

DESCRIPTION="Spine is a fast poller for Cacti (formerly known as Cactid)"
HOMEPAGE="https://cacti.net/spine_info.php"
SRC_URI="https://www.cacti.net/downloads/spine/${MY_P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~ppc64 ~sparc ~x86"

DEPEND="dev-db/mysql-connector-c:=
	dev-libs/openssl:=
	net-analyzer/net-snmp:="
RDEPEND="${DEPEND}
	>net-analyzer/cacti-0.8.8"
BDEPEND="sys-apps/help2man"

src_prepare() {
	default

	eautoreconf
}

src_configure() {
	# Drop CONFIG_SHELL after 1.2.x (fix is on develop branch)
	CONFIG_SHELL="${BROOT}"/bin/bash econf
}

src_install() {
	dosbin spine

	insinto /etc/
	insopts -m0640 -o root
	newins spine.conf{.dist,}

	doman spine.1
	dodoc CHANGELOG
}
