# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/castor/castor-0.9.9.1-r7.ebuild,v 1.3 2015/06/13 11:37:20 ago Exp $

EAPI=5

JAVA_PKG_IUSE="doc examples source"
JAVA_PKG_WANT_BOOTCLASSPATH="1.5"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Data binding framework for Java"
SRC_URI="http://dist.codehaus.org/${PN}/${PV}/${P}-src.tgz"
HOMEPAGE="http://www.castor.org"
LICENSE="Exolab"
KEYWORDS="amd64 x86"
SLOT="0.9"
IUSE=""

COMMON_DEP=">=dev-java/commons-logging-1.0.4
	dev-java/jakarta-oro:2.0
	dev-java/jakarta-regexp:1.3
	dev-java/ldapsdk:4.1
	dev-java/xerces:1.3
	dev-java/cglib:3
	java-virtuals/transaction-api"
RDEPEND=">=virtual/jre-1.6
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.6
	${COMMON_DEP}"

java_prepare() {
	# TODO this should be filed upstream
	epatch "${FILESDIR}/0.9.5.3-jikes.patch"

	# Does not like Java 1.6's JDBC API
	java-ant_rewrite-bootclasspath 1.5 src/build.xml

	cd "${S}/lib"
	rm -v *.jar || die
	#FIXME: uses these bundled classes
	rm -v tests/*.jar || die
	java-pkg_jar-from --build-only ant-core ant.jar
	#Only used by examples and tests and we aren't building them
	#java-pkg_jar-from adaptx-0.9
	java-pkg_jar-from commons-logging
	java-pkg_jar-from cglib-2
	java-pkg_jar-from jakarta-oro-2.0 jakarta-oro.jar oro.jar
	java-pkg_jar-from jakarta-regexp-1.3 jakarta-regexp.jar regexp.jar
	java-pkg_jar-from xerces-1.3
	java-pkg_jar-from ldapsdk-4.1 ldapjdk.jar
	java-pkg_jar-from transaction-api

	# Remove special characters
	cd ../

	ebegin 'Removing special characters'
	perl -i'' -npe 's/S.bastien/Sebastien/g;' src/main/org/exolab/castor/types/DateTimeBase.java
	perl -i'' -npe 's/.actual value./actual value/g;' src/main/org/exolab/castor/xml/schema/reader/ImportUnmarshaller.java
	eend $?
}

EANT_BUILD_XML="src/build.xml"

src_install() {
	java-pkg_newjar dist/${P}.jar
	java-pkg_newjar dist/${P}-xml.jar ${PN}-xml.jar

	use doc && java-pkg_dojavadoc build/doc/javadoc
	use examples && java-pkg_doexamples src/examples
	use source && java-pkg_dosrc src/main/org
}
