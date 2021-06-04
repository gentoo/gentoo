# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"
MAVEN_ID="org.bouncycastle:bcprov-jdk15on:1.52"

inherit java-pkg-2 java-pkg-simple

MY_P="${PN}-jdk15on-${PV/./}"

DESCRIPTION="Java cryptography APIs"
HOMEPAGE="http://www.bouncycastle.org/java.html"
SRC_URI="http://www.bouncycastle.org/download/${MY_P}.tar.gz"

LICENSE="BSD"
SLOT="1.52"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~x64-macos"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_P}"

JAVA_ENCODING="ISO-8859-1"

# Package can't be build with test as bcprov and bcpkix can't be built with test.
RESTRICT="test"

src_unpack() {
	default
	cd "${S}"
	unpack ./src.zip
}

src_prepare() {
	default
#	if ! use test; then
		# There are too many files to delete so we won't be using JAVA_RM_FILES
		# (it produces a lot of output).
		local RM_TEST_FILES=()
		while read -d $'\0' -r file; do
			RM_TEST_FILES+=("${file}")
		done < <(find . -name "*Test*.java" -type f -print0)
		while read -d $'\0' -r file; do
			RM_TEST_FILES+=("${file}")
		done < <(find . -name "*Mock*.java" -type f -print0)

		rm -v "${RM_TEST_FILES[@]}" || die
#	fi
}
