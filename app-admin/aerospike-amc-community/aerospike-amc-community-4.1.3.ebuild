# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Web UI based monitoring tool for Aerospike Community Edition Server"
HOMEPAGE="https://www.aerospike.com"
SRC_URI="https://github.com/aerospike-community/amc/releases/download/4.1.3/aerospike-amc-enterprise-4.1.3-linux.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	acct-group/aerospike-amc-community
	acct-user/aerospike-amc-community
"

RDEPEND="${DEPEND}"

S="${WORKDIR}"

src_install() {
	cp -r "${S}"/* "${D}"
	rm "${D}"/etc/init.d/amc || die
	newinitd "${FILESDIR}/amc.init.4" amc
}
