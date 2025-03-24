# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"
MAVEN_ID="com.google.guava:guava:${PV}-jre"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A collection of Google's core Java libraries"
HOMEPAGE="https://github.com/google/guava"
SRC_URI="https://github.com/google/guava/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"

CP_DEPEND="
	>=dev-java/error-prone-annotations-2.41.0:0
	dev-java/j2objc-annotations:0
	dev-java/jspecify:0
"

DEPEND="
	${CP_DEPEND}
	>=dev-java/checker-framework-qual-3.49.5:0
	dev-java/jsr305:0
	>=virtual/jdk-11:*
"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

JAVA_CLASSPATH_EXTRA="jsr305"

src_prepare() {
	java-pkg-2_src_prepare

	# Get module-info.class into versions/9
	mkdir -p futures/failureaccess/src9 || die "mkdir futures"
	mv futures/failureaccess/src{,9}/module-info.java || die "mv futures"
	mkdir -p guava/src9 || die "mkdir guava"
	mv guava/src{,9}/module-info.java || die "mv guava"
}

src_compile() {
	einfo "Compiling failureaccess.jar"
	JAVA_INTERMEDIATE_JAR_NAME="com.google.common.util.concurrent.internal"
	JAVA_JAR_FILENAME="failureaccess.jar"
	JAVA_RELEASE_SRC_DIRS=( ["9"]="futures/failureaccess/src9" )
	JAVA_SRC_DIR="futures/failureaccess/src"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":failureaccess.jar"
	rm -r target || die

	einfo "Compiling guava.jar"
	JAVA_CLASSPATH_EXTRA="checker-framework-qual"
	JAVA_INTERMEDIATE_JAR_NAME="com.google.common"
	JAVA_JAR_FILENAME="guava.jar"
	JAVA_RELEASE_SRC_DIRS=( ["9"]="guava/src9" )
	JAVA_SRC_DIR="guava/src"
	java-pkg-simple_src_compile
	JAVA_GENTOO_CLASSPATH_EXTRA+=":guava.jar"
	rm -r target || die

	JAVADOC_CLASSPATH="${JAVA_GENTOO_CLASSPATH}"
	JAVADOC_SRC_DIRS=( {futures/failureaccess,guava}/src )
	use doc && ejavadoc
}

src_install() {
	java-pkg-simple_src_install
	java-pkg_dojar failureaccess.jar
}
