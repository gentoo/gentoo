# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/mx4j-core/mx4j-core-3.0.2-r1.ebuild,v 1.3 2015/07/01 15:07:19 monsieurp Exp $

EAPI=5

inherit java-pkg-2 java-ant-2

MY_PN="${PN/-core/}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Open Source implementation of the JMX and JMX Remote API (JSR 160) specifications"
HOMEPAGE="http://mx4j.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}-src.tar.gz"

CDEPEND="dev-java/bcel:0
	dev-java/commons-logging:0
	dev-java/log4j:0"
DEPEND=">=virtual/jdk-1.6
	>=dev-java/ant-core-1.6
	source? ( app-arch/zip )
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

LICENSE="Apache-1.1"
SLOT="3.0"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE="doc source"

S="${WORKDIR}/${MY_P}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="bcel,commons-logging,log4j"

java_prepare() {
	epatch "${FILESDIR}/${P}-split-javadoc-build.patch"
}

src_compile() {
	eant -f build/build.xml \
		compile.jmx \
		compile.rjmx \
		$(use_doc javadocs.core)
}

src_install() {
	java-pkg_dojar dist/lib/*.jar
	dodoc README.txt
	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc "${S}/src/core/*"
}

pkg_postinst() {
	elog "This is a a new split ebuild for just the core jmx to reduce"
	elog "dependencies for packages that only require the core. You can"
	elog "find the examples in dev-java/mx4j and the tools in dev-java/mx4j-tools"
}
