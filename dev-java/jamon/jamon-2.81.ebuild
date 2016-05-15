# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

MY_PN="${PN}api"
MY_PV="${PV//./_}"
MY_P="${MY_PN}-${MY_PV}"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java API to monitor production applications"
HOMEPAGE="http://www.jamonapi.com/"
SRC_URI="https://github.com/stevensouza/${MY_PN}/archive/v${MY_PV}.tar.gz -> ${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE="test"

CDEPEND="dev-java/log4j:0
	java-virtuals/interceptor-api:0
	java-virtuals/servlet-api:3.0
	www-servers/tomcat:7"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.7
	dev-db/hsqldb:0
	dev-java/jakarta-oro:2.0"

DEPEND="${CDEPEND}
	>=virtual/jdk-1.7
	test? (
		dev-db/hsqldb:0
		dev-java/assertj-core:2
		dev-java/junit:4
		dev-java/mockito:0
		dev-java/objenesis:0
	)"

S="${WORKDIR}/${MY_P}"
JAVA_GENTOO_CLASSPATH="interceptor-api,log4j,servlet-api-3.0,tomcat-7"
JAVA_SRC_DIR="${PN}/src/main/java"
WAR_DIR="jamon_war/src/main/webapp"

java_prepare() {
	# No Jetty or Hazelcast packaged right now and Spring is ancient.
	find \( -name "*Jetty*.java" -o -name "*Hazelcast*.java" \) -exec rm -v {} + || die
	rm -rv ./jamon/src/test/java/com/jamonapi/distributed/JamonDataPersisterFactoryTest.java \
		./jamon/src/{main,test}/java/com/jamonapi/aop/spring || die

	# Keep fdsapi and xss-html-filter bundled as we lack packages.
	rm -v ${WAR_DIR}/WEB-INF/lib/{hsqldb,jakarta-oro}*.jar || die
}

src_compile() {
	java-pkg-simple_src_compile
	jar cf ${PN}.war -C ${WAR_DIR} . || die
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dowar ${PN}.war
	dodoc designnotes.txt README.md

	# hsqldb used by JSP files, oro used by fdsapi.
	java-pkg_register-dependency hsqldb,jakarta-oro-2.0
}

src_test() {
	cd jamon/src/test/java || die

	local CP=".:../resources:${S}/${PN}.jar:$(java-pkg_getjars assertj-core-2,hsqldb,junit-4,mockito,objenesis,${JAVA_GENTOO_CLASSPATH})"
	local TESTS=$(find * -name "*Test.java")
	TESTS="${TESTS//.java}"
	TESTS="${TESTS//\//.}"

	ejavac -cp "${CP}" -d . $(find * -name "*.java")
	ejunit4 -classpath "${CP}" ${TESTS}
}
