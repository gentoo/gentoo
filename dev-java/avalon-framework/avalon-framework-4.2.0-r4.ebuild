# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
# The tests themselves are JUnit 3 tests, but using
# junit-4 here causes 61 additional tests to be run
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Avalon Framework"
HOMEPAGE="https://avalon.apache.org/"
SRC_URI="mirror://apache/avalon/avalon-framework/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="4.2"
KEYWORDS="amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x86-solaris"

CP_DEPEND="
	dev-java/avalon-logkit:2.0
	dev-java/log4j-12-api:2
"

DEPEND="
	>=virtual/jdk-1.8:*
	${CP_DEPEND}
	test? (
		dev-java/junit:0
	)
"

RDEPEND="
	>=virtual/jre-1.8:*
	${CP_DEPEND}
"

S="${WORKDIR}/${PN}"

PATCHES=( "${FILESDIR}/4.2.0-enum.patch" )
DOCS=( NOTICE.TXT )

JAVA_SRC_DIR=( {api,impl}/src/java )

JAVA_TEST_GENTOO_CLASSPATH="junit"
JAVA_TEST_SRC_DIR=( {api,impl}/src/test )

src_prepare() {
	default # https://bugs.gentoo.org/780585
}

src_install() {
	java-pkg-simple_src_install
	einstalldocs # https://bugs.gentoo.org/789582
}
