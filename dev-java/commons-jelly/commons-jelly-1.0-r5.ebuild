# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2 eutils

MY_P="${P}-src"
DESCRIPTION="A Java and XML based scripting and processing engine"
HOMEPAGE="http://commons.apache.org/jelly/"
SRC_URI="mirror://apache/jakarta/commons/jelly/source/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="1"
KEYWORDS="amd64 x86"
IUSE=""

COMMON_DEP="
	dev-java/commons-beanutils:1.7
	dev-java/commons-cli:1
	dev-java/commons-collections:0
	dev-java/commons-discovery:0
	dev-java/commons-jexl:1.0
	dev-java/commons-lang:0
	dev-java/commons-logging:0
	dev-java/dom4j:1
	dev-java/jakarta-jstl:0
	dev-java/jaxen:1.1
	dev-java/junit:0
	java-virtuals/servlet-api:2.5"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.4"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.4
	test? ( dev-java/ant-junit:0 )"

S=${WORKDIR}/${MY_P}

java_prepare() {
	# disables dependency fetching, and remove tests as a dependency of jar
	epatch "${FILESDIR}/${P}-gentoo.patch"
}

JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_EXTRA_ARGS="-Dlibdir=."
EANT_GENTOO_CLASSPATH="
	commons-beanutils-1.7,commons-cli-1,commons-collections,commons-discovery
	commons-jexl-1.0,commons-lang,commons-logging,dom4j-1,jakarta-jstl
	jaxen-1.1,junit,servlet-api-2.5"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar target/${P}.jar ${PN}.jar

	dodoc NOTICE.txt README.txt RELEASE-NOTES.txt || die

	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/*
}
