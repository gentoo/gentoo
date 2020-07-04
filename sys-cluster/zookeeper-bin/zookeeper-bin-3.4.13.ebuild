# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1 eutils java-utils-2 user

MY_P="zookeeper"
MY_PN=${MY_P}-${PV}

DESCRIPTION="A high-performance coordination service for distributed applications."
HOMEPAGE="http://zookeeper.apache.org/"
SRC_URI="mirror://apache/${MY_P}/${MY_PN}/${MY_PN}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="mirror binchecks"
IUSE=""

DEPEND=""
RDEPEND=">=virtual/jre-1.7"

S=${WORKDIR}/${MY_PN}

INSTALL_DIR=/opt/${PN}
export CONFIG_PROTECT="${CONFIG_PROTECT} ${INSTALL_DIR}/conf"

pkg_setup() {
	enewgroup zookeeper
	enewuser zookeeper -1 /bin/sh /var/lib/zookeeper zookeeper
}

src_prepare() {
	# python
	sed -e "s|src/c/zookeeper.c|zookeeper.c|g" \
		-e "s|../../../|${S}|g" \
		-i contrib/zkpython/src/python/setup.py || die

	# whyyyy u -Werror ?! so horribal!
	sed -e 's/-Werror//g' -i src/c/Makefile.* || die "Failed to rectify the Makefile"
}

src_configure() {
	cd "${S}"/src/c || die
	econf
}

src_compile() {
	cd "${S}"/src/c || die
	emake
}

src_install() {
	local DATA_DIR=/var/lib/${MY_P}

	# python
	cd "${S}"/contrib/zkpython/ || die
	mv src/python/setup.py .
	mv src/c/* .
	python_foreach_impl distutils-r1_src_install
	cd "${S}" || die

	# cleanup sources
	rm -rf src/ || die
	rm bin/*.cmd || die

	keepdir "${DATA_DIR}"
	sed "s:^dataDir=.*:dataDir=${DATA_DIR}:" conf/zoo_sample.cfg > conf/zoo.cfg || die "sed failed"
	cp "${FILESDIR}"/log4j.properties conf/ || die "cp log4j conf failed"

	dodir "${INSTALL_DIR}"
	cp -a "${S}"/* "${D}${INSTALL_DIR}" || die "install failed"

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
		PATH=${INSTALL_DIR}/bin
		CONFIG_PROTECT=${INSTALL_DIR}/conf
	EOF
	doenvd 99"${PN}"
}
