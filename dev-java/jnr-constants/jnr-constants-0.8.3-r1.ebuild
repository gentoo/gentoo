# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2 vcs-snapshot

DESCRIPTION="A set of platform constants (e.g. errno values)"
HOMEPAGE="https://github.com/jnr/jnr-constants"
SRC_URI="https://github.com/jnr/${PN}/tarball/${PV} -> ${P}.tar.gz"

LICENSE="|| ( Apache-2.0 LGPL-3 )"
SLOT="0.8.2"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	>=virtual/jre-1.5"
DEPEND="
	>=virtual/jdk-1.5
	test? (
		dev-java/ant-junit:0
		>=dev-java/junit-4.8:4
	)"

java_prepare() {
	cp "${FILESDIR}"/${PN}_maven-build.xml build.xml || die
}

JAVA_ANT_ENCODING="UTF-8"
JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_EXTRA_ARGS="-Dmaven.build.finalName=${PN}"

EANT_TEST_GENTOO_CLASSPATH="junit-4"
src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar target/${PN}.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/*
}
