# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Ehcache is a pure Java, fully-featured, in-process cache"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"
HOMEPAGE="http://ehcache.sourceforge.net"

LICENSE="Apache-2.0"
SLOT="1.2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE=""

CDEPEND="dev-java/commons-collections:0
	dev-java/commons-logging:0
	java-virtuals/servlet-api:2.5"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	${CDEPEND}
	app-arch/unzip"

S="${WORKDIR}/${P}"
JAVA_GENTOO_CLASSPATH="commons-collections,commons-logging,servlet-api-2.5"

java_prepare() {
	unpack ./${P}-sources.jar
	rm -vr net/sf/ehcache/hibernate || die
	java-pkg_clean
}
