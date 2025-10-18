# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A Java port of Daniel Lemire's fast_float project"
HOMEPAGE="https://github.com/wrandelshofer/FastDoubleParser/"
SRC_URI="https://github.com/wrandelshofer/FastDoubleParser/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/FastDoubleParser-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"

DEPEND=">=virtual/jdk-25:*"
RDEPEND=">=virtual/jre-1.8:*"

JAVA_INTERMEDIATE_JAR_NAME="ch.randelshofer.fastdoubleparser"
JAVA_RELEASE_SRC_DIRS=(
	["11"]="fastdoubleparser-java11/src/main/java"
	["17"]="fastdoubleparser-java17/src/main/java"
	["21"]="fastdoubleparser-java21/src/main/java"
	["23"]="fastdoubleparser-java23/src/main/java"
)
JAVA_SRC_DIR="fastdoubleparser-java8/src/main/java"

src_prepare() {
	java-pkg-2_src_prepare
	rm fastdoubleparser-java11/src/main/java/ch.randelshofer.fastdoubleparser/ch/randelshofer/fastdoubleparser/NumberFormatSymbols.java || die
	pushd fastdoubleparser-dev > /dev/null || die "pushd"
		find src/main/java -type f -name '*.java' \
			! -name 'BigSignificand.java' \
			! -name 'Decimal.java' \
			! -name 'FastDoubleSwar.java' \
			! -name 'FastDoubleVector.java' \
			! -name 'FastIntegerMath.java' \
			! -name 'NumberFormatSymbols.java' \
			! -name 'module-info.java' |
			xargs cp --parent -t ../fastdoubleparser-java8 || die "java8"

		find src/main/java -type f \
			-name 'BigSignificand.java' |
			xargs cp --parent -t ../fastdoubleparser-java11 || die "java11"

		find src/main/java -type f \
			-name 'FastIntegerMath.java' |
			xargs cp --parent -t ../fastdoubleparser-java17 || die "java17"

		find src/main/java -type f \
			-name 'FastIntegerMath.java' |
			xargs cp --parent -t ../fastdoubleparser-java21 || die "java21"

		find src/main/java -type f \
			\( -name 'FastDoubleSwar.java' \
			-o -name 'FastIntegerMath.java' \) |
			xargs cp --parent -t ../fastdoubleparser-java23 || die "java23"
	popd > /dev/null || die "popd"
}
