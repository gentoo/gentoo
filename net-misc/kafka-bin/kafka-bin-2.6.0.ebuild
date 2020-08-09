# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils

DESCRIPTION="A high-throughput distributed messaging system"
HOMEPAGE="https://kafka.apache.org/"

# pick recommended scala version
SCALA_VERSION=2.13
MY_PN="kafka"
MY_P="${MY_PN}_${SCALA_VERSION}-${PV}"
SRC_URI="mirror://apache/kafka/${PV}/${MY_P}.tgz"

RESTRICT="mirror"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="internal-zookeeper"

COMMON_DEPEND="acct-group/kafka
	acct-user/kafka
	virtual/jre:1.8"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/${MY_P}"
INSTALL_DIR="/opt/${MY_PN}"

src_prepare() {
	sed -i -e 's:/tmp/zookeeper:/var/lib/kafka/zookeeper:' "config/zookeeper.properties" || die
	sed -i -e 's:/tmp/kafka-logs:/var/lib/kafka/logs:' "config/server.properties" || die
	eapply_user
}

src_install() {
	insinto /etc/kafka
	doins config/zookeeper.properties config/server.properties
	if use "internal-zookeeper"; then
		keepdir /var/lib/kafka/zookeeper
		newinitd "${FILESDIR}/${MY_PN}-zookeeper.init.d" "${MY_PN}-zookeeper"
	fi

	keepdir /var/lib/kafka
	fowners -R kafka:kafka /var/lib/kafka

	keepdir /var/log/kafka
	fowners -R kafka:kafka /var/log/kafka

	newinitd "${FILESDIR}/${MY_PN}.init.d.4" "${MY_PN}"

	dodir "${INSTALL_DIR}"
	cp -pRP bin config libs "${ED}/${INSTALL_DIR}" || die
	keepdir "${INSTALL_DIR}/logs"
	fowners -R kafka:kafka "${INSTALL_DIR}"
}
