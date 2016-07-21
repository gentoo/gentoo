# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Lightweight cross-platform POSIX emulation layer for Java"
HOMEPAGE="https://github.com/jnr/"
SRC_URI="https://github.com/jnr/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="|| ( CPL-1.0 GPL-2 LGPL-2.1 )"
SLOT="1.1"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

COMMON_DEP="
	dev-java/jnr-constants:0.8.2
	dev-java/jnr-ffi:0.5"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.5"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.5
	test? (
		dev-java/ant-junit
		dev-java/junit:4
	)"

src_unpack() {
	unpack ${A}
	mv jnr-jnr-posix-* ${P} || die
}

java_prepare() {
	cp "${FILESDIR}"/${PN}_maven-build.xml build.xml || die
}

JAVA_ANT_REWRITE_CLASSPATH="yes"
JAVA_ANT_CLASSPATH_TAGS="${JAVA_ANT_CLASSPATH_TAGS} javadoc"
JAVA_ANT_ENCODING="UTF-8"

EANT_GENTOO_CLASSPATH="jnr-constants-0.8.2,jnr-ffi-0.5"
EANT_EXTRA_ARGS="-Dmaven.build.finalName=${PN} -Dmaven.build.srcDir.0=src"

EANT_TEST_GENTOO_CLASSPATH="${EANT_GENTOO_CLASSPATH},junit-4"
EANT_TEST_EXTRA_ARGS="-Dmaven.build.testDir.0=test"
src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar target/${PN}.jar
	dodoc README.txt

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/*
}
