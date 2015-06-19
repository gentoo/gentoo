# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/mx4j-tools/mx4j-tools-3.0.2.ebuild,v 1.4 2012/12/02 08:31:21 ulm Exp $

EAPI=1

inherit eutils java-pkg-2 java-ant-2

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

RDEPEND="
	dev-java/bcel
	dev-java/commons-logging
	dev-java/log4j
	=www-servers/axis-1*
	dev-java/hessian:4.0
	dev-java/jython:2.5
	java-virtuals/servlet-api:2.3
	java-virtuals/jaf
	java-virtuals/javamail"
#    >=www-servers/jetty-4.2
DEPEND="${RDEPEND}
	>=virtual/jdk-1.5
	>=dev-java/ant-core-1.6
	source? ( app-arch/zip )"
RDEPEND="${RDEPEND}
	>=virtual/jre-1.5"

LICENSE="Apache-1.1"
SLOT="3.0"
KEYWORDS="~amd64 ~x86"
IUSE="doc source"

S="${WORKDIR}/${MY_P}"

src_unpack() {
	unpack ${A}

	cd "${S}"
	epatch "${FILESDIR}/${P}-split-javadoc-build.patch"
	epatch "${FILESDIR}/${P}-new-hessian.patch"

	cd "${S}/lib"
	java-pkg_jar-from bcel bcel.jar
	java-pkg_jar-from commons-logging commons-logging.jar
	java-pkg_jar-from log4j
	java-pkg_jar-from axis-1
	java-pkg_jar-from --virtual servlet-api-2.3 servlet.jar

	# optionals
#    java-pkg_jar-from jetty org.mortbay.jetty.jar
	java-pkg_jar-from hessian-4.0
	java-pkg_jar-from jython-2.5 jython.jar
	java-pkg_jar-from --virtual jaf
	java-pkg_jar-from --virtual javamail
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

pkg_postinst() {
	elog
	elog "This package is currently built without Jetty support. Jetty support will be"
	elog "added when Jetty is brought up-to-date in Portage with the new Java system."
	elog "To track Jetty progress, see the following:"
	elog
	elog "  http://bugs.gentoo.org/show_bug.cgi?id=94452"
	elog "  http://bugs.gentoo.org/show_bug.cgi?id=147469"
	elog
}
