# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="examples doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java framework for easy creation/rendering of documents"
HOMEPAGE="http://velocity.apache.org"
SRC_URI="mirror://apache/${PN}/engine/${PV}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

CDEPEND="
	dev-java/jdom:0
	dev-java/log4j:0
	dev-java/ant-core:0
	dev-java/werken-xpath:0
	dev-java/jakarta-oro:2.0
	dev-java/avalon-logkit:2.0
	dev-java/commons-lang:2.1
	dev-java/commons-logging:0
	dev-java/commons-collections:0
	java-virtuals/servlet-api:2.3
"
DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6
"
RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

JAVA_GENTOO_CLASSPATH="
	jdom
	log4j
	ant-core
	werken-xpath
	jakarta-oro-2.0
	servlet-api-2.3
	commons-logging
	commons-lang-2.1
	avalon-logkit-2.0
	commons-collections
"

JAVA_SRC_DIR="src"

RESTRICT="test"

S="${WORKDIR}/${P}"

java_prepare() {
	java-pkg_clean
	rm -rf test src/test || die
}

src_install() {
	java-pkg-simple_src_install
	use examples && java-pkg_doexamples examples
}
