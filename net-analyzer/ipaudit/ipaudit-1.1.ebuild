# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="IPAudit monitors network activity on a network by host, protocol and port"
HOMEPAGE="https://ipaudit.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-2+"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="mysql"

RDEPEND="
	net-libs/libpcap
	sys-libs/zlib:=
	mysql? ( dev-db/mysql-connector-c:= )"
DEPEND="${RDEPEND}"

src_configure() {
	econf $(use_with mysql)
}
