# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

# TODO: Get doc (missing classpath entries) working.
JAVA_PKG_IUSE="source test"

inherit vcs-snapshot java-pkg-2 java-ant-2

DESCRIPTION="A library that allows you to use ANSI escape sequences in your console output"
HOMEPAGE="http://jansi.fusesource.org/"
SRC_URI="https://github.com/fusesource/${PN}/archive/${PN}-project-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 ppc64 x86"

CDEPEND="dev-java/jansi-native:0"

DEPEND="${CDEPEND}
	test? (
		dev-java/ant-junit4:0
		dev-java/junit:4
	)
	>=virtual/jdk-1.8:*"

RDEPEND="${CDEPEND}
	>=virtual/jre-1.8:*"

S="${WORKDIR}/${P}/jansi"

EANT_GENTOO_CLASSPATH="jansi-native"
JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_SRC_DIR="src/main/java"

src_prepare() {
	default
	cp "${FILESDIR}"/${P}-build.xml build.xml || die
}

EANT_TEST_GENTOO_CLASSPATH="ant-junit4,junit-4"

src_test() {
	EANT_EXTRA_ARGS="-Djunit.present=true"

	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar target/${P}.jar ${PN}.jar

	use source && java-pkg_dosrc src/main/java/org
}
