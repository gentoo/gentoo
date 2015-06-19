# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/spring-beans/spring-beans-3.2.4.ebuild,v 1.1 2013/10/18 16:48:40 ercpe Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A comprehensive programming and configuration model for modern Java-based enterprise applications"
HOMEPAGE="http://www.springsource.org/spring-framework"
SRC_URI="https://github.com/SpringSource/spring-framework/archive/v${PV}.RELEASE.tar.gz -> spring-framework-${PV}.tar.gz
		http://dev.gentoo.org/~ercpe/distfiles/dev-java/spring-framework/spring-framework-${PV}-buildscripts.tar.bz2"

LICENSE="Apache-2.0"
SLOT="3.2"
KEYWORDS="~amd64 ~x86"

IUSE=""

CDEPEND="
	dev-java/commons-logging:0
	java-virtuals/servlet-api:3.0
	dev-java/javax-inject:0
	dev-java/spring-core:${SLOT}"

DEPEND=">=virtual/jdk-1.7
	test? (
		dev-java/hamcrest-core:1.3
		dev-java/hamcrest-library:1.3
		dev-java/junit:4
		dev-java/mockito:0
		dev-java/ant-junit4:0
		dev-java/xmlunit:1
	)
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.7
	${CDEPEND}"

S="${WORKDIR}/spring-framework-${PV}.RELEASE/"

EANT_BUILD_XML=${S}/${PN}/build.xml

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="spring-core-${SLOT},commons-logging,servlet-api-3.0,javax-inject"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH}
	hamcrest-library-1.3
	hamcrest-core-1.3
	junit-4
	mockito
	xmlunit-1"

src_install() {
	java-pkg_dojar "${S}"/${PN}/dist/${PN}.jar

	use source && java-pkg_dosrc "${S}"/${PN}/src/main/java/org/
	use doc && java-pkg_dojavadoc "${S}"/${PN}/dist/apidocs/
}

src_test() {
	java-pkg-2_src_test
}
