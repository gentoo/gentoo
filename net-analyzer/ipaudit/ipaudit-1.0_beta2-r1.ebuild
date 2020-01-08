# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="IPAudit monitors network activity on a network by host, protocol and port"
HOMEPAGE="http://ipaudit.sourceforge.net/"
MY_P="${PN}-${PV/_beta/BETA}"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"
LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ppc x86"
IUSE="mysql"
DEPEND="net-libs/libpcap
		mysql? ( dev-db/mysql-connector-c:0= )"
RDEPEND="${DEPEND}"
S="${WORKDIR}/${MY_P}"

DOCS=( AUTHORS README )

src_configure() {
	econf $(use_with mysql)
}
