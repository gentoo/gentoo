# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Ehcache is a pure Java, fully-featured, in-process cache"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"
HOMEPAGE="http://ehcache.sourceforge.net"

LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

COMMON_DEPEND="
		dev-java/commons-collections:0
		dev-java/concurrent-util:0
		dev-java/commons-logging:0"
RDEPEND=">=virtual/jre-1.4
		${COMMON_DEPEND}"
DEPEND=">=virtual/jdk-1.4
		app-arch/zip
		${COMMON_DEPEND}
		>=dev-java/ant-core-1.5"

S="${WORKDIR}/${P}"

JAVA_GENTOO_CLASSPATH="commons-collections,concurrent-util,commons-logging"

java_prepare() {
	unzip ${P}-src.zip || die
	rm *.jar || die
	rm -rf src/net/sf/ehcache/hibernate || die
}
