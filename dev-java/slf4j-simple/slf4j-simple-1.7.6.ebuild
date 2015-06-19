# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/slf4j-simple/slf4j-simple-1.7.6.ebuild,v 1.1 2014/03/12 22:55:31 radhermit Exp $

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Simple Logging Facade for Java"
HOMEPAGE="http://www.slf4j.org/"
SRC_URI="http://www.slf4j.org/dist/${P/-simple/}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

COMMON_DEP="dev-java/slf4j-api:0"
RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	${COMMON_DEP}
	test? ( dev-java/junit )"

S="${WORKDIR}/${P/-simple/}/${PN}"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="slf4j-api"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit-4"
EANT_TEST_ANT_TASKS="ant-junit"
EANT_EXTRA_ARGS="-Dmaven.build.finalName=${PN}"

java_prepare() {
	cp "${FILESDIR}"/${PV}-build.xml build.xml || die
	find "${S}" -name "*.jar" -delete || die
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar target/${PN}.jar
	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/org
}
