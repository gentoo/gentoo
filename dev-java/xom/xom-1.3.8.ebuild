# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="XML Object Model"
HOMEPAGE="https://xom.nu"
SRC_URI="https://github.com/elharo/${PN}/releases/download/v${PV}/${P}-src.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~x86-solaris"

CP_DEPEND="
	dev-java/jaxen:1.2
	dev-java/xerces:2"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*"

DEPEND="
	${CP_DEPEND}
	dev-java/junit:0
	>=virtual/jdk-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="nu.xom"
JAVA_MAIN_CLASS="nu.xom.Info"
JAVA_RESOURCE_DIRS="src/main/resources"
JAVA_SRC_DIR="src/main/java"

JAVA_TEST_GENTOO_CLASSPATH="junit"
JAVA_TEST_SRC_DIR="src/test/java"

src_prepare() {
	java-pkg-2_src_prepare

	# removing directories based on build.xml
	rm -rv XOM/src/nu/xom/benchmarks/ || die
	rm -rv XOM/src/nu/xom/integrationtests/ || die
	rm -rv XOM/src/nu/xom/samples/ || die
	rm -rv XOM/src/nu/xom/tools/ || die

	# reorganize the code and resources so that it goes well with java-pkg-simple
	mkdir -pv ${JAVA_SRC_DIR} ${JAVA_RESOURCE_DIRS} ${JAVA_TEST_SRC_DIR}/nu/xom || die
	mv -v {XOM/src,${JAVA_TEST_SRC_DIR}}/nu/xom/tests || die
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
