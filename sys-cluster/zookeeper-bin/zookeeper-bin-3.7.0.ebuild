# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-utils-2

MY_PN="zookeeper"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="A high-performance coordination service for distributed applications"
HOMEPAGE="https://zookeeper.apache.org/"
SRC_URI="https://downloads.apache.org/${MY_PN}/${MY_P}/apache-${MY_P}-bin.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror binchecks"

RDEPEND="
	acct-group/zookeeper
	acct-user/zookeeper
	>=virtual/jre-1.8
"

S="${WORKDIR}/apache-${MY_P}-bin"

INSTALL_DIR=/opt/"${PN}"
export CONFIG_PROTECT="${CONFIG_PROTECT} ${INSTALL_DIR}/conf"

src_prepare() {
	eapply_user
	rm "${S}"/docs/skin/instruction_arrow.png || die "failed to remove broken png"
}

src_install() {
	local DATA_DIR=/var/lib/"${MY_P}"

	# cleanup sources
	rm bin/*.cmd || die "rm *.cmd files failed"

	keepdir "${DATA_DIR}"
	sed "s:^dataDir=.*:dataDir=${DATA_DIR}:" conf/zoo_sample.cfg > conf/zoo.cfg || die "sed failed"
	cp "${FILESDIR}"/log4j.properties conf/ || die "cp log4j conf failed"

	dodir "${INSTALL_DIR}"
	cp -a "${S}"/* "${ED}${INSTALL_DIR}" || die "install failed"

	# data dir perms
	fowners zookeeper:zookeeper "${DATA_DIR}"

	# log dir
	keepdir /var/log/zookeeper
	fowners zookeeper:zookeeper /var/log/zookeeper

	# init script
	newinitd "${FILESDIR}"/zookeeper.initd zookeeper
	newconfd "${FILESDIR}"/zookeeper.confd zookeeper

	# env file
	cat > 99"${PN}" <<-EOF
		PATH="${INSTALL_DIR}"/bin
		CONFIG_PROTECT="${INSTALL_DIR}"/conf
	EOF
	doenvd 99"${PN}"
}
