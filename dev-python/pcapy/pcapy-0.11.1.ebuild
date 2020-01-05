# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_6} )

inherit distutils-r1

DESCRIPTION="Python pcap extension"
HOMEPAGE="https://www.coresecurity.com/corelabs-research/open-source-tools/pcapy"
SRC_URI="https://github.com/CoreSecurity/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="${DEPEND}
	 net-libs/libpcap"

python_test() {
	cd "${S}/tests" || die "Unable to activate test suite"
	 "${EPYTHON}" pcapytests.py || die "Tests failed with ${EPYTHON}"
}
