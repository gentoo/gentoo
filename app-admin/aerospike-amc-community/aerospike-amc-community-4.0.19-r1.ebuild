# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit eutils user

DESCRIPTION="Web UI based monitoring tool for Aerospike Community Edition Server"
HOMEPAGE="http://www.aerospike.com"
SRC_URI="http://www.aerospike.com/download/amc/${PV}/artifact/linux -> ${P}.tar.gz"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

S=${WORKDIR}

src_install() {
	cp -r "$S/"* "$D"
	rm "${D}/etc/init.d/*"
	newinitd "${FILESDIR}/amc.init.4" amc
}
