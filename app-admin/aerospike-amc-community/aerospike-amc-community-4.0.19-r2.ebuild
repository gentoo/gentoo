# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Web UI based monitoring tool for Aerospike Community Edition Server"
HOMEPAGE="http://www.aerospike.com"
SRC_URI="http://www.aerospike.com/download/amc/${PV}/artifact/linux -> ${P}.tar.gz"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	acct-group/aerospike-amc
	acct-user/aerospike-amc
"

src_install() {
	cp -r "${S}/"* "${ED}"
	rm "${ED}/etc/init.d/*"
	newinitd "${FILESDIR}/amc.init.4" amc
}
