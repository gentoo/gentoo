# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

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
IUSE="internal-zookeeper connect"

COMMON_DEPEND="acct-group/kafka
	acct-user/kafka
	|| ( virtual/jre:1.8 virtual/jre:11 )"
DEPEND="${COMMON_DEPEND}"
RDEPEND="${COMMON_DEPEND}"

S="${WORKDIR}/${MY_P}"
INSTALL_DIR="/opt/${MY_PN}"

src_prepare() {
	sed -i -e 's:/tmp/zookeeper:/var/lib/kafka/zookeeper:' "config/zookeeper.properties" || die
	sed -i -e 's:/tmp/kafka-logs:/var/lib/kafka/logs:' "config/server.properties" || die
	sed -i -e 's:/tmp/connect.offsets:/var/lib/kafka/connect.offsets:' "config/connect-standalone.properties" || die
	eapply_user
}

src_install() {
	insinto /etc/kafka
	doins config/zookeeper.properties config/server.properties
	if use "internal-zookeeper"; then
		keepdir /var/lib/kafka/zookeeper
		newinitd "${FILESDIR}/${MY_PN}-zookeeper.init.d" "${MY_PN}-zookeeper"

		ewarn "Zookeeper owner has been changed to kafka:kafka"
		ewarn "you might want to run chown -R kafka:kafka /var/lib/kafka/zookeeper"
		ewarn "or set COMMAND_USER=\"root:root\" in /etc/conf.d/kafka-zookeeper"
		ewarn "to keep the previous behavior."
		ewarn "All logs files have been move to /var/log/kafka/"
	fi

	if use "connect"; then
		doins config/connect-distributed.properties config/connect-standalone.properties
		newinitd "${FILESDIR}/${MY_PN}-connect-distributed.init.d" "${MY_PN}-connect-distributed"
	fi

	keepdir /var/lib/kafka
	fowners -R kafka:kafka /var/lib/kafka

	keepdir /var/log/kafka
	fowners -R kafka:kafka /var/log/kafka

	newinitd "${FILESDIR}/${MY_PN}.init.d.5" "${MY_PN}"

	dodir "${INSTALL_DIR}"
	cp -pRP bin config libs "${ED}/${INSTALL_DIR}" || die
	keepdir "${INSTALL_DIR}/logs"
	fowners -R kafka:kafka "${INSTALL_DIR}"
}
