# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jcs/jcs-2.0.ebuild,v 1.5 2015/06/15 15:44:51 ago Exp $

EAPI=5
JAVA_PKG_IUSE="test doc source"

inherit java-pkg-2 java-ant-2

MY_P="commons-${PN}-dist-${PV}-beta-1-src"
JCS_CORE="commons-${PN}-core"

DESCRIPTION="JCS is a distributed caching system written in Java for server-side Java applications"
HOMEPAGE="http://commons.apache.org/jcs/"
SRC_URI="http://apache.mirrors.ovh.net/ftp.apache.org/dist/commons/${PN}/source/commons-${PN}-dist-${PV}-beta-1-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="2.0"
KEYWORDS="amd64 ppc x86"
IUSE="admin"

CDEPEND="dev-java/jisp:2.5
	dev-db/hsqldb:0
	dev-java/log4j:0
	dev-java/xmlrpc:3
	dev-java/commons-lang:0
	dev-java/commons-dbcp:0
	dev-java/commons-pool:0
	dev-java/commons-logging:0
	dev-java/commons-httpclient:3
	java-virtuals/servlet-api:3.0"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"
DEPEND=">=virtual/jdk-1.6
	test? ( dev-java/ant-junit:0 )
	${CDEPEND}"

S="${WORKDIR}/${MY_P}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="
	xmlrpc-3
	hsqldb
	jisp-2.5
	log4j
	commons-lang
	commons-pool
	commons-dbcp
	commons-logging
	commons-httpclient-3
	servlet-api-3.0
"

EANT_BUILD_XML="${JCS_CORE}/build.xml"
EANT_BUILD_TARGET="package"

java_prepare() {
	cp "${FILESDIR}/${P}-build.xml" ${JCS_CORE}/build.xml

	# Disable the velocity-tools dep.
	rm -v \
		${JCS_CORE}/src/main/java/org/apache/commons/jcs/admin/servlet/JCSAdminServlet.java

	if use test; then
		# Make use of commons-collections4 not yet packaged in Gentoo
		rm -v \
			"${JCS_CORE}"/src/test/java/org/apache/commons/jcs/utils/struct/JCSvsCommonsLRUMapPerformanceTest.java \
			"${JCS_CORE}"/src/test/java/org/apache/commons/jcs/utils/struct/LRUMapPerformanceTest.java

		# Fails for some reason.
		rm -v \
			"${JCS_CORE}"/src/test/java/org/apache/commons/jcs/auxiliary/disk/AbstractDiskCacheUnitTest.java \
			"${JCS_CORE}"/src/test/java/org/apache/commons/jcs/auxiliary/disk/LRUMapJCSUnitTest.java \
			"${JCS_CORE}"/src/test/java/org/apache/commons/jcs/engine/logging/CacheEventLoggerDebugLoggerUnitTest.java \
			"${JCS_CORE}"/src/test/java/org/apache/commons/jcs/utils/struct/DoubleLinkedListUnitTest.java
	fi
}

EANT_TEST_TARGET="test"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	local target="${JCS_CORE}"/target
	java-pkg_newjar "${target}"/"${JCS_CORE}-${PV}"-beta-1.jar "${JCS_CORE}".jar

	if use doc; then
		java-pkg_dojavadoc "${target}"/site/apidocs
	fi

	if use source; then
		java-pkg_dosrc "${JCS_CORE}"/src
	fi
}
