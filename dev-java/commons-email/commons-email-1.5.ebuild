# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Commons Email aims to provide an API for sending email"
HOMEPAGE="https://commons.apache.org/email"
SRC_URI="https://repo1.maven.org/maven2/org/apache/commons/${PN}/${PV}/${P}-sources.jar -> ${P}.jar"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

CDEPEND="dev-java/oracle-javamail:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

JAVA_GENTOO_CLASSPATH="oracle-javamail"
