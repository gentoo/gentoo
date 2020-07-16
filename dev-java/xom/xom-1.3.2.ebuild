# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="XML Object Model"
HOMEPAGE="http://cafeconleche.org/XOM/index.html"
SRC_URI="https://repo1.maven.org/maven2/${PN}/${PN}/${PV}/${P}-sources.jar -> ${P}.jar"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x86-solaris"

CDEPEND="
	dev-java/xerces:2
	dev-java/jaxen:1.1
	dev-java/xml-commons-external:1.3"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

JAVA_GENTOO_CLASSPATH="
	xerces-2
	jaxen-1.1
	xml-commons-external-1.3"

JAVA_SRC_DIR="nu"

src_prepare() {
	default

	rm -r nu/xom/integrationtests/ || die
}
