# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"
JAVA_TESTING_FRAMEWORKS="junit"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="XML Object Model"
HOMEPAGE="https://xom.nu"
SRC_URI="https://github.com/elharo/xom/releases/download/v1.3.7/xom-1.3.7-src.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x86-solaris"

CDEPEND="
	dev-java/jaxen:1.2
	dev-java/junit:0
	dev-java/xerces:2"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8:*"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.8:*"

JAVA_GENTOO_CLASSPATH="jaxen-1.2,junit,xerces-2"
JAVA_SRC_DIR="XOM/src/nu"

JAVA_TEST_GENTOO_CLASSPATH="junit"
JAVA_TEST_SRC_DIR="XOM/tests"

src_prepare() {
	default

	java-pkg_clean

	# removing directories based on build.xml
	rm -rv XOM/src/nu/xom/benchmarks/ || die
	rm -rv XOM/src/nu/xom/integrationtests/ || die
	rm -rv XOM/src/nu/xom/samples/ || die
	rm -rv XOM/src/nu/xom/tools/ || die

	mkdir -pv XOM/tests/nu/xom/ || die
	mv -v XOM/src/nu/xom/tests XOM/tests/nu/xom/|| die
}
