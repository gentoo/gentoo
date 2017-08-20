# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A Java XPath Engine"
HOMEPAGE="https://github.com/codehaus"
SRC_URI="https://repo1.maven.org/maven2/${PN}/${PN}/${PV}/${P}-sources.jar -> ${P}.jar"

LICENSE="JDOM"
SLOT="1.1"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"
IUSE=""

CDEPEND="
	dev-java/dom4j:1
	dev-java/jdom:0
	dev-java/xom:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

JAVA_GENTOO_CLASSPATH="
	xom
	jdom
	dom4j-1
"
