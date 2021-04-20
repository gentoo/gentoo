# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A Java XPath Engine"
HOMEPAGE="https://github.com/codehaus"
SRC_URI="https://repo1.maven.org/maven2/${PN}/${PN}/${PV}/${P}-sources.jar -> ${P}.jar"

LICENSE="JDOM"
SLOT="1.1"
KEYWORDS="~amd64 ~arm ~arm64 ppc64 ~x86"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8:*"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.8:*"

JAVA_SRC_DIR="org"

src_prepare() {
	default

	# xom depends on jaxen already. if we don't remove xom packages here and
	# require jaxen to depend on xom, we end up in a circular dep.
	# I fear though that removing those classes might bite us somewhere down
	# the line...
	rm -rv org/jaxen/{dom4j,jdom,xom} || die

	# this is now part of jdk
	rm -rv org/w3c || die
}
