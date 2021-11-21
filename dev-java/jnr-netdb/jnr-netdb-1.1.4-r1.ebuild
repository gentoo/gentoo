# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Network services database access for java"
HOMEPAGE="https://github.com/jnr/jnr-netdb"
SRC_URI="https://github.com/jnr/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="1.0"
KEYWORDS="amd64 ~arm64 ~ppc64 x86"

COMMON_DEP="
	dev-java/jnr-ffi:2"

RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.8:*"

DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.8:*
	test? (
		dev-java/ant-junit
		dev-java/junit:4
	)"

src_prepare() {
	default
	find -name '*.jar' -exec rm -v {} + || die

	cp "${FILESDIR}"/${PN}_maven-build.xml build.xml || die
}

JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS="${JAVA_ANT_CLASSPATH_TAGS} javadoc"
JAVA_ANT_ENCODING="UTF-8"

EANT_GENTOO_CLASSPATH="jnr-ffi-2"
EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit-4"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar target/${PN}.jar
	dodoc README

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/*
}
