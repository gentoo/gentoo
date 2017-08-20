# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Cluster-aware Caching for Java"
HOMEPAGE="http://swarmcache.sourceforge.net"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
LICENSE="LGPL-2"
SLOT="0"

CDEPEND="
	dev-java/jgroups:0
	dev-java/ant-core:0
	dev-java/commons-logging:0
	dev-java/commons-collections:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

JAVA_GENTOO_CLASSPATH="
	jgroups
	ant-core
	commons-logging
	commons-collections
"
