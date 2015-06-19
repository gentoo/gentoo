# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/hessian/hessian-3.0.8-r5.ebuild,v 1.7 2014/08/10 20:14:33 slyfox Exp $

EAPI=1
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A binary web service protocol"
HOMEPAGE="http://www.caucho.com/hessian/"
SRC_URI="http://www.caucho.com/hessian/download/${P}-src.jar"

LICENSE="Apache-1.1"
SLOT="3.0.8"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEP="java-virtuals/servlet-api:2.3
		dev-java/caucho-services:3.0"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${COMMON_DEP}"

JAVA_PKG_FILTER_COMPILER="jikes"

src_unpack() {
	mkdir -p ${P}/src
	cd ${P}/src
	unpack ${A}

	# They package stuff from burlap in here
	# Burlap is a separate protocol
	rm -fr "${S}/src/com/caucho/burlap"
	rm -fr "${S}/src/com/caucho/services"

	cd "${S}"
	epatch "${FILESDIR}/3.0.8-java5.patch"

	# No included ant script! Bad Java developer, bad!
	cp "${FILESDIR}/build-${PV}.xml" build.xml

	# Populate classpath
	echo "classpath=$(java-pkg_getjars servlet-api-2.3):$(java-pkg_getjars caucho-services-3.0)" >> build.properties
}

EANT_EXTRA_ARGS="-Dproject.name=${PN}"

src_install() {
	java-pkg_dojar dist/${PN}.jar

	use doc && java-pkg_dojavadoc dist/doc/api
	use source && java-pkg_dosrc src/com
}
