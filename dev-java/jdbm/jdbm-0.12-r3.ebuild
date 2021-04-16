# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Jdbm aims to be for Java what GDBM is for Perl, Python, C, ..."
HOMEPAGE="http://jdbm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"

LICENSE="BSD"
SLOT="1"
KEYWORDS="amd64 x86"

# Needs to depend on 1.3 because this uses assert
# so we need -source 1.3 here.
RDEPEND="
	>=virtual/jre-1.3"

DEPEND="
	app-arch/unzip
	>=virtual/jdk-1.3"

PATCHES=( "${FILESDIR}/${P}-buildfile.patch" )

src_prepare() {
	default
	java-pkg_clean
}

src_compile() {
	cd "${S}/src" || die
	java-pkg-2_src_compile
}

src_install() {
	java-pkg_dojar dist/${PN}.jar
	use doc && java-pkg_dojavadoc build/doc/javadoc
	use source && java-pkg_dosrc src/main/*
}
