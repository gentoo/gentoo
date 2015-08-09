# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="SwarmCache is a simple but effective distributed cache"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
HOMEPAGE="http://swarmcache.sourceforge.net"
LICENSE="LGPL-2"
SLOT="1.0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

COMMON_DEP=">=dev-java/commons-collections-3
	>=dev-java/commons-logging-1.0.4
	>=dev-java/jgroups-2.2.7"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.4
	${COMMON_DEP}
	>=dev-java/ant-core-1.5"

src_unpack() {
	unpack ${A}

	cd "${S}/lib"
	java-pkg_jar-from commons-collections
	java-pkg_jar-from commons-logging
	java-pkg_jar-from jgroups
}

#Tests seem to start a server that just waits
#src_test() {
#	eant test
#}
RESTRICT="test"

src_install() {
	java-pkg_dojar dist/${PN}.jar

	dodoc *.txt
	use doc && java-pkg_dojavadoc web/api
	use source && java-pkg_dosrc src/net
}
