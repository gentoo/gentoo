# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Sun XML Datatypes Library"
HOMEPAGE="http://msv.java.net/"
SRC_URI="http://java.net/downloads/msv/releases/${PN}.${PV}.zip"

LICENSE="BSD Apache-1.1"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

COMMON_DEP="
	dev-java/xerces:2
	dev-java/relaxng-datatype:0"
BDEPEND="app-arch/unzip"
RDEPEND="${COMMON_DEP}
	>=virtual/jre-1.4"
DEPEND="${COMMON_DEP}
	>=virtual/jdk-1.4"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR=( "src" "src-apache" )
JAVA_GENTOO_CLASSPATH="relaxng-datatype,xerces-2"

src_prepare() {
	default
	find -name '*.jar' -delete || die
}

src_compile() {
	java-pkg-simple_src_compile

	local dir; for dir in "${JAVA_SRC_DIR[@]}"; do
		pushd ${dir} > /dev/null || die
		jar -uf "${S}"/${PN}.jar $(find -name '*.properties') || die
		popd > /dev/null || die
	done
}

src_install() {
	java-pkg-simple_src_install

	dodoc README.txt
	docinto html
	dodoc HowToUse.html
}
