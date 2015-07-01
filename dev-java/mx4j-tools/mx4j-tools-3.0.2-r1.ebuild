# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/mx4j-tools/mx4j-tools-3.0.2-r1.ebuild,v 1.5 2015/07/01 15:06:47 monsieurp Exp $

EAPI=5

inherit java-pkg-2 java-ant-2

MY_P=${P/-tools/}
MY_PN=${PN/-tools/}

DESCRIPTION="Optional tool classes and utilities for MX4J"
HOMEPAGE="http://mx4j.sourceforge.net/"
SRC_URI="mirror://sourceforge/${MY_PN}/${MY_P}-src.tar.gz"

# The ${S}/BUILD-HOWTO is a good source for dependencies
# This package could also be built with jdk-1.3; see special
# handling instructions in ${S}/BUILD-HOWTO.

# javamail and jython support is optional but because ant-core puts it in the classpath
# if it is installed we can't force disable it without modifying the build.xml
# and jikes refuses to compile mx4j with javamail support disabled

# Optional jetty support can be enabled after jetty uses java-pkg_dojar to install jars

CDEPEND="dev-java/bcel:0
	dev-java/ant-core:0
	dev-java/commons-logging:0
	dev-java/log4j:0
	www-servers/axis:1
	dev-java/hessian:4.0
	dev-java/jython:2.7
	java-virtuals/servlet-api:3.0
	java-virtuals/jaf:0
	java-virtuals/javamail:0"
DEPEND=">=virtual/jdk-1.6
	source? ( app-arch/zip )
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

LICENSE="Apache-1.1"
SLOT="3.0"
KEYWORDS="amd64 x86"
IUSE="doc source"

S="${WORKDIR}/${MY_P}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="bcel,commons-logging,log4j,axis-1,servlet-api-3.0,hessian-4.0,jython-2.7,jaf,javamail"

java_prepare() {
	epatch "${FILESDIR}/${P}-split-javadoc-build.patch"
	epatch "${FILESDIR}/${P}-new-hessian.patch"
}

src_compile() {
	eant -f build/build.xml compile.tools $(use_doc javadocs.tools)
}

src_install() {
	java-pkg_dojar dist/lib/mx4j-tools.jar
	java-pkg_dowar dist/lib/mx4j-soap.war

	dodoc README.txt
	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc "${S}/src/tools/*"
}
