# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jnr-constants/jnr-constants-0.8.6.ebuild,v 1.3 2015/06/17 09:20:23 monsieurp Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A set of platform constants (e.g. errno values)"
HOMEPAGE="https://github.com/jnr/jnr-constants"
# SRC_URI="https://github.com/jnr/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
SRC_URI="https://github.com/jnr/${PN}/archive/${P}.tar.gz"

LICENSE="|| ( Apache-2.0 LGPL-3 )"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6
	test? (
		dev-java/ant-junit:0
		>=dev-java/junit-4.8:4
	)"

S="${WORKDIR}/${PN}-${P}"

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
