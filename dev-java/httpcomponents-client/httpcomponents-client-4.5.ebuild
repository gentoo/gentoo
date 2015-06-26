# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/httpcomponents-client/httpcomponents-client-4.5.ebuild,v 1.3 2015/06/26 07:19:59 ago Exp $

EAPI="5"

JAVA_PKG_IUSE="source examples doc test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A low level toolset of Java components focused on HTTP and associated protocols"
HOMEPAGE="http://hc.apache.org/index.html"
SRC_URI="mirror://apache/${PN/-//http}/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="4.5"
KEYWORDS="amd64 x86"

CDEPEND="
	dev-java/ant-junit:0
	dev-java/easymock:3.2
	dev-java/spymemcached:0
	dev-java/osgi-core-api:0
	dev-java/osgi-enterprise-api:0
	dev-java/commons-codec:0
	dev-java/commons-logging:0
	dev-java/httpcomponents-core:4.4
	dev-java/easymock-classextension:3.2
"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	test? (
		dev-java/junit:4
		dev-java/mockito:0
	)
	${CDEPEND}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="
	commons-codec
	commons-logging
	spymemcached
	osgi-core-api
	osgi-enterprise-api
	httpcomponents-core-4.4
"

# List of modules to compile and test.
MODULES=(
	httpclient
	httpclient-cache
	httpmime
	fluent-hc
	httpclient-osgi
)

EANT_BUILD_TARGET="package"
EANT_GENTOO_CLASSPATH_EXTRA="${S}/${MODULES[0]}/target/${MODULES[0]}-${PV}.jar"

java_prepare() {
	# copy build.xml files to their location.
	for module in ${MODULES[@]}; do
		cd "${S}"/"${module}" || die
		cp "${FILESDIR}"/"${PN}-${module}-${PV}"-build.xml build.xml
	done

	cd "${S}" || die

	# httpclient:
	# - copy deprecated sources for compilation
	cp -r "${S}"/${MODULES[0]}/src/main/java-deprecated/* \
		"${S}"/${MODULES[0]}/src/main/java/* || die

	# - remove broken tests
	rm -v ${MODULES[0]}/src/test/java/org/apache/http/client/config/TestRequestConfig.java

	# httpclient-cache:
	# - copy deprecated sources into main repository
	cp -r "${S}"/${MODULES[1]}/src/main/java-deprecated/* \
		"${S}"/${MODULES[1]}/src/main/java || die

	# - remove broken tests
	rm -v \
		${MODULES[1]}/src/test/java/org/apache/http/impl/client/cache/TestCachingExec*

	# - disable ehcache support altogether
	# the version in Portage is very old and compilation chokes on missing imports
	rm -rf \
		"${S}"/${MODULES[1]}/src/main/java/org/apache/http/impl/client/cache/ehcache \
		"${S}"/${MODULES[1]}/src/test/java/org/apache/http/impl/client/cache/ehcache

	# httpmime:
	# - copy deprecated sources into main repository
	cp -r "${S}"/${MODULES[2]}/src/main/java-deprecated/* \
		"${S}"/${MODULES[2]}/src/main/java

	# fluent-hc:
	# remove broken tests.
	rm -v ${MODULES[3]}/src/test/java/org/apache/http/client/fluent/TestFluent.java
}

EANT_TEST_GENTOO_CLASSPATH="
	${EANT_GENTOO_CLASSPATH}
	junit-4
	mockito
	easymock-3.2
	easymock-classextension-3.2
"

src_compile() {
	for module in ${MODULES[@]}; do
		EANT_BUILD_XML="${module}/build.xml" \
			java-pkg-2_src_compile
	done
}

src_test() {
	for module in ${MODULES[@]}; do
		ANT_TASKS= \
			EANT_BUILD_XML="${module}/build.xml" \
			java-pkg-2_src_test
	done
}

src_install() {
	for module in ${MODULES[@]}; do
		java-pkg_newjar ${module}/target/${module}-${PV}.jar ${module}.jar
	done

	if use source; then

		java-pkg_dosrc {httpclient,httpclient-cache,httpmime,fluent-hc}/src/main/java/org
	fi

	if use examples; then
		for dir in $(find "${S}" -mindepth 3 -maxdepth 4 -name "examples" -type d -print); do
			java-pkg_doexamples ${dir}/*
		done
	fi

	if use doc; then
		java-pkg_dojavadoc {httpclient,httpclient-cache,httpmime,fluent-hc}/target/site/apidocs/
	fi
}
