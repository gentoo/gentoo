# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.google.zxing:core:3.5.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Core barcode encoding/decoding library"
HOMEPAGE="https://zxing.github.io/zxing/"
SRC_URI="https://github.com/zxing/zxing/archive/zxing-${PV}.tar.gz"
S="${WORKDIR}/zxing-zxing-${PV}/core"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="amd64 ~arm64"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_AUTOMATIC_MODULE_NAME="com.google.zxing"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_RESOURCE_DIRS=( "src/test/resources" )
JAVA_TEST_SRC_DIR="src/test/java"
JAVA_TEST_EXCLUDES=(
	# not runnable
	com.google.zxing.common.TestResult
	com.google.zxing.oned.rss.expanded.TestCaseUtil
)
