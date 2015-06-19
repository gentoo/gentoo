# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ehcache/ehcache-1.2.4-r3.ebuild,v 1.4 2015/03/27 10:28:18 ago Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Ehcache is a pure Java, fully-featured, in-process cache"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"
HOMEPAGE="http://ehcache.sourceforge.net"

LICENSE="Apache-2.0"
SLOT="1.2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

COMMON_DEPEND="
	dev-java/commons-collections:0
	dev-java/commons-logging:0
	java-virtuals/servlet-api:2.4"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEPEND}
	app-arch/unzip"

S="${WORKDIR}/${P}"

JAVA_PKG_WANT_SOURCE="1.4"
JAVA_PKG_WANT_TARGET="1.4"
JAVA_SRC_DIR="src"

JAVA_GENTOO_CLASSPATH="commons-collections,commons-logging,servlet-api-2.4"

java_prepare() {
	unzip -d src ${P}-sources.jar || die
	rm -rf src/net/sf/ehcache/hibernate || die
	rm *.jar || die
}
