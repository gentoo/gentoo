# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source examples"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A generic, reliable, fast & flexible logging framework for Java"
HOMEPAGE="http://logback.qos.ch/"
SRC_URI="http://logback.qos.ch/dist/${PN}-${PV}.tar.gz
		http://dev.gentoo.org/~ercpe/distfiles/${CATEGORY}/${PN}/${P}-build.tar.bz2"

LICENSE="|| ( EPL-1.0 LGPL-2.1 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="tomcat"

CDEPEND="dev-java/janino:0
	dev-java/jansi:0
	java-virtuals/javamail:0
	java-virtuals/servlet-api:2.5
	dev-java/slf4j-api:0
	tomcat? ( www-servers/tomcat:7 )
"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"
DEPEND="${CDEPEND}
	>=virtual/jdk-1.5"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="janino,jansi,javamail,servlet-api-2.5,slf4j-api"
EANT_GENTOO_CLASSPATH_EXTRA="${S}/${PN}-core/target/${PN}-core.jar"

java_prepare() {
	find "${S}" -name "*.jar" -delete || die

	use tomcat || rm -r "${S}"/${PN}-access/src/main/java/ch/qos/logback/access/tomcat/ || die
	# remove the next line when we have jetty in the tree
	rm -r "${S}"/${PN}-access/src/main/java/ch/qos/logback/access/jetty/ || die

	use tomcat && EANT_GENTOO_CLASSPATH+=",tomcat-7"
}

src_install() {
	java-pkg_dojar "${S}"/${PN}-core/target/${PN}-core.jar
	java-pkg_dojar "${S}"/${PN}-access/target/${PN}-access.jar

	use source && java-pkg_dosrc "${S}"/${PN}-core/src/main/java "${S}"/${PN}-access/src/main/java
	use doc && java-pkg_dojavadoc "${S}"/${PN}-core/target/site/apidocs
	use examples && java-pkg_doexamples "${S}"/${PN}-examples/src/main/java/chapters/*
}
