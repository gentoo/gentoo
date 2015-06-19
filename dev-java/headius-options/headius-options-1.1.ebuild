# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/headius-options/headius-options-1.1.ebuild,v 1.2 2015/04/02 18:09:32 mr_bones_ Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A small library for managing sets of JVM properties"
HOMEPAGE="https://github.com/headius/options"
SRC_URI="https://github.com/headius/options/archive/options-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux ~x86-macos"

S="${WORKDIR}/options-options-${PV}"

RDEPEND=">=virtual/jre-1.7"
DEPEND=">=virtual/jdk-1.7
	test? (
		dev-java/ant-junit:0
		>=dev-java/junit-4.8:4
	)"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_TEST_GENTOO_CLASSPATH="ant-junit junit-4"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml build.xml || die
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar target/options-${PV}.jar

	dodoc README.md

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/com
}
