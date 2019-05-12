# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="XMPP client library for instant messaging and presence"
HOMEPAGE="http://www.jivesoftware.org/smack"
SRC_URI="https://repo1.maven.org/maven2/org/igniterealtime/${PN}/${PN}/${PV}/${P}-sources.jar -> ${P}.jar"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/xpp3:0"

DEPEND="
	>=virtual/jdk-1.6
	${CDEPEND}"

RDEPEND="
	>=virtual/jre-1.6
	${CDEPEND}"

JAVA_GENTOO_CLASSPATH="xpp3"

JAVA_SRC_DIR="org"
