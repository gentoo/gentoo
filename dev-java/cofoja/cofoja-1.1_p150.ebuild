# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Contracts for Java"
HOMEPAGE="https://code.google.com/p/cofoja/"
SRC_URI="http://dev.gentoo.org/~ercpe/distfiles/${CATEGORY}/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RESTRICT="test"

CDEPEND="dev-java/asm:4"
DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_BUILD_TARGET="dist"
EANT_GENTOO_CLASSPATH="asm-4"

java_prepare() {
	cat << EOF > "${S}"/local.properties
version=${PV}
snapshot=false
debug=false
EOF

	java-pkg_jar-from --into build asm-4 asm.jar
}

src_install() {
	java-pkg_newjar "${S}"/dist/${P}.jar ${PN}.jar
	use source && java-pkg_dosrc "${S}"/src/com
}
