# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_P="aerospike-amc-enterprise-${PV}-linux"

DESCRIPTION="Web UI based monitoring tool for Aerospike Community Edition Server"
HOMEPAGE="https://www.aerospike.com"
SRC_URI="https://github.com/aerospike-community/amc/releases/download/${PV}/${MY_P}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	acct-group/aerospike-amc
	acct-user/aerospike-amc
"

QA_PREBUILT="/opt/amc/amc"

src_install() {
	cp -r "${S}"/* "${ED}" || die
	rm "${ED}"/etc/init.d/amc || die
	newinitd "${FILESDIR}/amc.init.4" amc
}
