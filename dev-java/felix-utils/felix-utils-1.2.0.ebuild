# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

inherit java-pkg-2 java-ant-2 java-osgi

DESCRIPTION="Felix Utils"
HOMEPAGE="http://felix.apache.org/"
LICENSE="Apache-2.0"

MY_PN="org.apache.felix.utils"
MY_P="${MY_PN}-${PV}"
SRC_URI="mirror://apache/felix/${MY_P}-source-release.tar.gz"
SLOT="0"
KEYWORDS="amd64"

DEPEND=">=virtual/jdk-1.6
	dev-java/felix-gogo-runtime:0
	dev-java/osgi-compendium:0
	dev-java/osgi-core-api:0"

RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/${MY_P}"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml build.xml || die

	epatch "${FILESDIR}"/${P}-java-fixes.patch
}

JAVA_ANT_REWRITE_CLASSPATH="true"

src_compile() {
	EANT_EXTRA_ARGS="-Dgentoo.classpath=$(java-pkg_getjar --build-only osgi-core-api osgi-core-api.jar):$(java-pkg_getjar --build-only osgi-compendium osgi-compendium.jar):$(java-pkg_getjar --build-only felix-gogo-runtime felix-gogo-runtime.jar)"

	java-pkg-2_src_compile
}

src_install() {
	mv "${S}"/target/{${MY_P},${PN}}.jar || die

	java-osgi_dojar "${S}"/target/${PN}.jar ${MY_PN} ${MY_PN} "Export-Package: ${MY_PN}"
}
