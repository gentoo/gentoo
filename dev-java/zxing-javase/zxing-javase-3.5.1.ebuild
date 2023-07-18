# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
MAVEN_ID="com.google.zxing:javase:3.5.1"
JAVA_TESTING_FRAMEWORKS="junit-4"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Core barcode encoding/decoding library"
HOMEPAGE="https://github.com/zxing/zxing/core"
SRC_URI="https://github.com/zxing/zxing/archive/zxing-${PV}.tar.gz"
LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="amd64 ~arm ~arm64 ~x86"

CP_DEPEND="
	dev-java/jcommander:0
	dev-java/zxing-core:3
"
DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"
RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

S="${WORKDIR}/zxing-zxing-${PV}/javase"

JAVA_AUTOMATIC_MODULE_NAME="com.google.zxing.javase"
JAVA_SRC_DIR="src/main/java"
JAVA_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_TEST_SRC_DIR="src/test/java"
