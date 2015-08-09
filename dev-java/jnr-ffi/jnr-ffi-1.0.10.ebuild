# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="An abstracted interface to invoking native functions from java"
HOMEPAGE="https://github.com/jnr/jnr-ffi"
SRC_URI="https://github.com/jnr/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="|| ( Apache-2.0 LGPL-3 )"
SLOT="1"
KEYWORDS="amd64 x86"

COMMON_DEP="
	dev-java/jffi:1.2
	dev-java/jnr-x86asm:1.0
	dev-java/asm:4"

RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.5"

DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.5
	test? (
		dev-java/ant-junit:0
		>=dev-java/junit-4.8:4
	)"

java_prepare() {
	cp "${FILESDIR}"/${PN}_maven-build.xml build.xml || die
	epatch "${FILESDIR}"/${PN}-1.0.6-junit48.patch
}

JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS="${JAVA_ANT_CLASSPATH_TAGS} javadoc"
JAVA_ANT_ENCODING="UTF-8"

EANT_GENTOO_CLASSPATH="asm-4,jffi-1.2,jnr-x86asm-1.0"
EANT_EXTRA_ARGS="-Dmaven.build.finalName=${PN}"

EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit-4"

src_test() {
	# build native test library
	emake BUILD_DIR=build -f libtest/GNUmakefile

	_JAVA_OPTIONS="-Djnr.ffi.library.path=build" \
		java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar target/${PN}.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/*
}
