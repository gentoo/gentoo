# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit java-pkg-2 java-ant-2 java-osgi

DESCRIPTION="Felix Gogo Command"
HOMEPAGE="http://felix.apache.org/site/apache-felix-gogo.html"
LICENSE="Apache-2.0"

MY_PN="org.apache.felix.gogo.command"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://apache/felix/${MY_P}-project.tar.gz"
SLOT="0"
KEYWORDS="amd64"

CDEPEND="
	dev-java/felix-bundlerepository:0
	dev-java/felix-gogo-runtime:0
	dev-java/osgi-compendium:0
	dev-java/osgi-core-api:0
"

DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

S="${WORKDIR}/${MY_P}"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml build.xml || die
}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="osgi-core-api,osgi-compendium,felix-gogo-runtime,felix-bundlerepository"

src_install() {
	mv target/{${MY_P},${PN}}.jar || die

	java-osgi_dojar target/${PN}.jar ${MY_PN} ${MY_PN} "Export-Package: ${MY_PN}"
}
