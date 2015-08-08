# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PV=${PV/_/}

DESCRIPTION="Open source implementation of Service Provisioning Markup Language (SPML)"
HOMEPAGE="http://www.openspml.org/"
SRC_URI="http://www.openspml.org/Files/${PN}_v${PV}.zip"

LICENSE="openspml"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND=">=dev-java/soap-2.3.1-r4:0
		java-virtuals/javamail:0"

RDEPEND="${CDEPEND}
		>=virtual/jre-1.6"
DEPEND="${CDEPEND}
	app-arch/unzip
	>=virtual/jdk-1.6"

S="${WORKDIR}/${PN}"

JAVA_SRC_DIR="src"
JAVA_GENTOO_CLASSPATH="soap,javamail"
JAVAC_ARGS="-source 1.4"

java_prepare() {
	rm -r "${S}"/src/org/openspml/test/ || die
	rm "${S}"/lib/*.jar || die
}
