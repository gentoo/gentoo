# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jansi/jansi-1.11.ebuild,v 1.1 2013/06/04 17:48:28 tomwij Exp $

EAPI="5"

# TODO: Get tests (misses junit jar) and doc (missing classpath entries) working.
JAVA_PKG_IUSE="source test"
RESTRICT="test"

inherit vcs-snapshot java-pkg-2 java-ant-2

DESCRIPTION="Jansi is a small java library that allows you to use ANSI escape sequences in your console output"
HOMEPAGE="http://jansi.fusesource.org/"
SRC_URI="https://github.com/fusesource/${PN}/tarball/${PN}-project-${PV} -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/jansi-native:0"

DEPEND="${CDEPEND}
	test? ( dev-java/junit:4 )
	>=virtual/jdk-1.5"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"

S="${WORKDIR}/${P}/jansi"

EANT_GENTOO_CLASSPATH="jansi-native"
JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_SRC_DIR="src/main/java"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml build.xml || die
}

EANT_TEST_GENTOO_CLASSPATH="junit-4"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar target/${P}.jar ${PN}.jar

	use source && java-pkg_dosrc src/main/java/org
}
