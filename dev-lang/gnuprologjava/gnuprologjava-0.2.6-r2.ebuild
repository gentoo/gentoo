# Copyright 2016-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="GNU Prolog for Java is an implementation of ISO Prolog as a Java library"
HOMEPAGE="https://www.gnu.org/software/gnuprologjava/"
SRC_URI="mirror://gnu/gnuprologjava/${P}-src.zip"

LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="amd64"

BDEPEND="app-arch/unzip"
CP_DEPEND="dev-java/java-getopt:1"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*
	doc? ( sys-apps/texinfo )"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

DOCS=( NEWS.txt docs/readme.txt )
PATCHES=( "${FILESDIR}/${P}-manual.patch" )

JAVA_RESOURCE_DIRS="res"
JAVA_SRC_DIR="src"

src_prepare() {
	default #780585
	java-pkg-2_src_prepare
	rm -r src/gnu/getopt || die
	mkdir res || die
	pushd src > /dev/null || die
	find -type f \
		! -name '*.java' \
		| xargs cp --parent -t ../res || die
	popd > /dev/null || die
	if use doc; then
		mkdir manual || die
		makeinfo --html docs/manual.texinfo --output=manual
	fi
}

src_install() {
	java-pkg-simple_src_install
	if use doc; then
		docinto html
		dodoc -r manual || die
	fi
}
