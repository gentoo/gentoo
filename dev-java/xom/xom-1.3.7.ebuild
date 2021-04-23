# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="XML Object Model"
HOMEPAGE="https://xom.nu"
SRC_URI="https://github.com/elharo/${PN}/releases/download/v${PV}/${P}-src.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x86-solaris"

CDEPEND="
	dev-java/jaxen:1.2
	dev-java/xerces:2"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8:*"

DEPEND="
	${CDEPEND}
	dev-java/junit:0
	>=virtual/jdk-1.8:*"

JAVA_GENTOO_CLASSPATH="jaxen-1.2,xerces-2"
JAVA_SRC_DIR="src/main/java"
JAVA_RESOURCE_DIRS="src/main/resources"

JAVA_TEST_GENTOO_CLASSPATH="junit"
JAVA_TEST_SRC_DIR="src/test/java"

PATCHES=(
	"${FILESDIR}/${P}-disable-invalid-test.patch"
)

src_prepare() {
	default

	java-pkg_clean

	# removing directories based on build.xml
	rm -rv XOM/src/nu/xom/benchmarks/ || die
	rm -rv XOM/src/nu/xom/integrationtests/ || die
	rm -rv XOM/src/nu/xom/samples/ || die
	rm -rv XOM/src/nu/xom/tools/ || die

	# reorganize the code and resources so that it goes well with java-pkg-simple
	mkdir -pv ${JAVA_SRC_DIR} ${JAVA_RESOURCE_DIRS} ${JAVA_TEST_SRC_DIR}/nu/xom || die
	mv -v XOM/src/nu/xom/tests ${JAVA_TEST_SRC_DIR}/nu/xom/ || die
	mv -v XOM/data . || die
	pushd XOM/src || die
	for file in $(find -type f -name "*.java"); do
		cp --parents -R ${file} "${WORKDIR}/${JAVA_SRC_DIR}" || die
	done
	for file in $(find -type f ! -name "*.java"); do
		cp --parents -R ${file} "${WORKDIR}/${JAVA_RESOURCE_DIRS}" || die
	done
	popd
}
