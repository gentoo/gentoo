# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/felix-bundlerepository/felix-bundlerepository-1.6.6.ebuild,v 1.2 2015/07/27 08:43:48 monsieurp Exp $

EAPI="5"

inherit java-pkg-2 java-ant-2 java-osgi

DESCRIPTION="Felix Bundle Repository"
HOMEPAGE="http://felix.apache.org/"
LICENSE="Apache-2.0"

MY_PN="org.apache.felix.bundlerepository"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://apache/felix/${MY_P}-source-release.tar.gz"
SLOT="0"
KEYWORDS="~amd64"

CDEPEND="
	dev-java/kxml:2
	dev-java/xpp3:0
	dev-java/felix-shell:0
	dev-java/felix-utils:0
	dev-java/osgi-core-api:0
	dev-java/osgi-obr:0
"

DEPEND=">=virtual/jdk-1.5
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

S="${WORKDIR}/${MY_P}"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml build.xml || die

	sed -i 's/bestVersion.compareTo(v)/bestVersion.compareTo((Version) v)/g' \
		src/main/java/org/apache/felix/bundlerepository/impl/ResolverImpl.java \
		|| die
}

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="osgi-core-api,felix-utils,felix-shell,xpp3,kxml-2,osgi-obr"

src_install() {
	mv target/{${MY_P},${PN}}.jar || die

	java-osgi_dojar target/${PN}.jar ${MY_PN} ${MY_PN} "Export-Package: ${MY_PN}"
}
