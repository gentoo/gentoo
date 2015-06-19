# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/ehcache/ehcache-1.2.4-r2.ebuild,v 1.8 2014/08/10 20:12:55 slyfox Exp $

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Ehcache is a pure Java, fully-featured, in-process cache"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"
HOMEPAGE="http://ehcache.sourceforge.net"

LICENSE="Apache-2.0"
SLOT="1.2"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x86-macos"
IUSE=""

COMMON_DEPEND="
	dev-java/commons-collections
	dev-java/commons-logging
	~dev-java/servletapi-2.4"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEPEND}
	app-arch/unzip
	source? ( app-arch/zip )
	>=dev-java/ant-core-1.5"

JAVA_PKG_WANT_SOURCE="1.4"
JAVA_PKG_WANT_TARGET="1.4"

src_unpack() {

	unpack ${A}
	cd "${S}"

	use doc && unzip -qq ${P}-javadoc.zip

	mkdir src && cd src
	unzip -qq ../${P}-sources.jar

	# could use a USE flag, but would result in circular dep
	rm -rf net/sf/ehcache/hibernate

	cd "${S}"
	rm -f *.jar *.zip
	cp "${FILESDIR}/build.xml-${PVR}" build.xml || die
	mv "${S}/ehcache.xml" "${S}/ehcache-failsafe.xml" || die

	mkdir "${S}"/lib
	cd "${S}"/lib

	java-pkg_jarfrom commons-logging
	java-pkg_jarfrom commons-collections
	java-pkg_jarfrom servletapi-2.4

}

src_compile() {
	eant jar
}

src_install() {
	java-pkg_dojar ${PN}.jar

	dodoc *.txt ehcache.xsd
	use source && java-pkg_dosrc src/net
	use doc &&java-pkg_dojavadoc docs
}
