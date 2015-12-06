# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2 eutils

MY_PN=ws-${PN}
MY_P=${MY_PN}-${PV}
DESCRIPTION="JaxMe 2 is an open source implementation of JAXB, the specification for Java/XML binding"
HOMEPAGE="http://ws.apache.org/jaxme/index.html"
SRC_URI="mirror://apache/ws/${PN}/source/${MY_P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"
IUSE=""

COMMON_DEP=">=dev-java/antlr-2.7.7-r7:0
	>=dev-java/log4j-1.2.8:0
	dev-java/junit:0
	dev-java/xmldb:0"

RDEPEND=">=virtual/jre-1.6
	dev-java/xerces:2
	${COMMON_DEP}"

DEPEND=">=virtual/jdk-1.6
	dev-db/hsqldb:0
	${COMMON_DEP}"

S="${WORKDIR}/${MY_P}"

# We do it later
JAVA_PKG_BSFIX="off"

java_prepare() {
	cd "${S}/prerequisites"
	rm *.jar
	java-pkg_jarfrom antlr
	java-pkg_jarfrom junit
	java-pkg_jarfrom log4j log4j.jar log4j-1.2.8.jar
	java-pkg_jarfrom xmldb xmldb-api.jar xmldb-api-20021118.jar
	java-pkg_jarfrom xmldb xmldb-api-sdk.jar xmldb-api-sdk-20021118.jar
	java-pkg_jarfrom --build-only ant-core ant.jar ant-1.5.4.jar
	java-pkg_jarfrom --build-only ant-core ant.jar ant.jar
	# no linking to it, should be used for tests only but used to generate stuff during build anyway
	java-pkg_jarfrom --build-only hsqldb hsqldb.jar hsqldb-1.7.1.jar

	# Special case: jaxme uses ant/*.xml files, so rewriting them by hand
	# is better:
	cd "${S}"
	for i in build.xml ant/*.xml src/webapp/build.xml src/test/jaxb/build.xml; do
		java-ant_bsfix_one "${i}"
	done

	# Patch marshal classes to be abstract for build to succeed
	epatch "${FILESDIR}/${P}-fix_marshallers.patch"
}

EANT_TEST_ANT_TASKS="hsqldb"

src_compile() {
	local ant_target="all"
	local ant_args=""
	if use doc; then
		ant_args="-Dbuild.apidocs=dist/doc/api"
		# The javadoc target depends on all so it is enough. Passing both results in two builds,
		# where the second pass fails due to hsqldb lock - bug #310311.
		ant_target="javadoc"
	fi

	eant ${ant_args} ${ant_target}
}

src_install() {
	# Not entirely optional but this avoids a warning at build time and
	# RDEPEND will enforce its presence anyway.
	java-pkg_register-optional-dependency xerces-2

	pushd dist > /dev/null
	for jar in *.jar; do
		java-pkg_newjar ${jar} ${jar/-${PV}/}
	done
	popd > /dev/null

	dodoc NOTICE

	if use doc; then
		java-pkg_dojavadoc dist/doc/api
		dohtml -r src/documentation/manual
	fi
	use source && java-pkg_dosrc src/{pm,jaxme,js,api,webapp,xs}/*
}
