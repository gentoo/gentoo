# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-pkg-simple

MY_PN="${PN}-jdk16"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Java cryptography APIs"
HOMEPAGE="http://www.bouncycastle.org/java.html"
SRC_URI="http://central.maven.org/maven2/org/bouncycastle/${MY_PN}/${PV}/${MY_P}-sources.jar"
LICENSE="BSD"
SLOT="1.45"
KEYWORDS="amd64 ppc ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos"

CDEPEND=""

DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

JAVA_ENCODING="ISO-8859-1"
JAVA_SRC_DIR="org"

# Package can't be built with test as bcprov and bcpkix can't be built with test.
RESTRICT="test"

java_prepare() {
	if ! use test; then
		# There are too many files to delete so we won't be using JAVA_RM_FILES
		# (it produces a lot of output).
		local RM_TEST_FILES=()
		while read -d $'\0' -r file; do
			RM_TEST_FILES+=("${file}")
		done < <(find . -name "*Test*.java" -type f -print0)
		while read -d $'\0' -r file; do
			RM_TEST_FILES+=("${file}")
		done < <(find . -name "*Mock*.java" -type f -print0)

		rm -v "${RM_TEST_FILES[@]}"
	fi
}

src_compile() {
	java-pkg-simple_src_compile
}

src_install() {
	java-pkg-simple_src_install
	use source && java-pkg_dosrc org
}
