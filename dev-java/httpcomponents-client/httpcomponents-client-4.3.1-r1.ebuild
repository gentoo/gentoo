# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/httpcomponents-client/httpcomponents-client-4.3.1-r1.ebuild,v 1.2 2015/04/02 18:31:30 mr_bones_ Exp $

EAPI="5"

JAVA_PKG_IUSE="source examples doc test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A low level toolset of Java components focused on HTTP and associated protocols"
HOMEPAGE="http://hc.apache.org/index.html"
SRC_URI="mirror://apache/${PN/-//http}/source/${P}-src.tar.gz
		http://dev.gentoo.org/~ercpe/distfiles/${CATEGORY}/${PN}/${P}-build.tar.bz2"

LICENSE="Apache-2.0"
SLOT="4.3"
KEYWORDS="~amd64 ~x86"
IUSE="deprecated"

CDEPEND="
	dev-java/commons-codec:0
	dev-java/commons-logging:0
	dev-java/httpcomponents-core:${SLOT}[deprecated]
	dev-java/ehcache:1.2
	dev-java/spymemcached:0
	dev-java/easymock-classextension:3.2
"

RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.5
	test? (
		dev-java/junit:4
		dev-java/mockito:0
	)
	${CDEPEND}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="commons-codec,commons-logging,httpcomponents-core-${SLOT},ehcache-1.2,spymemcached"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit-4,mockito,easymock-classextension-3.2"
EANT_TEST_ANT_TASKS="ant-junit"

java_prepare() {
	# The Ehcache cache storage depends on a version of Ehcache
	# (with a .replace(Element, Element) method) >= 2.2.0 which can only be built
	# with the proprietary terracotta library
	rm "${S}"/httpclient-cache/src/main/java/org/apache/http/impl/client/cache/ehcache/EhcacheHttpCacheStorage.java \
		"${S}"/httpclient-cache/src/test/java/org/apache/http/impl/client/cache/ehcache/TestEhcacheHttpCacheStorage.java \
		"${S}"/httpclient-cache/src/test/java/org/apache/http/impl/client/cache/ehcache/TestEhcacheProtocolRequirements.java || die

	if use deprecated; then
		cp -r "${S}"/httpclient/src/main/java-deprecated/* \
				"${S}"/httpclient/src/main/java/* || die
		cp -r "${S}"/httpclient-cache/src/main/java-deprecated/* \
				"${S}"/httpclient-cache/src/main/java/* || die
		cp -r "${S}"/httpmime/src/main/java-deprecated/* \
				"${S}"/httpmime/src/main/java/* || die
	fi
}

src_install() {
	java-pkg_dojar httpclient/target/httpclient.jar \
					httpclient-cache/target/httpclient-cache.jar \
					httpmime/target/httpmime.jar \
					fluent-hc/target/fluent-hc.jar

	use source && java-pkg_dosrc {httpclient,httpclient-cache,httpmime,fluent-hc}/src/main/java/org
	use examples && java-pkg_doexamples $(find "${S}" -mindepth 3 -maxdepth 3 -name "examples" -type d -print)
	use doc && java-pkg_dojavadoc apidocs/
}

src_test() {
	java-pkg-2_src_test
}
