# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Jdbm aims to be for Java what GDBM is for Perl, Python, C, ..."
HOMEPAGE="http://jdbm.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"

LICENSE="BSD"
SLOT="1"
KEYWORDS="amd64 x86"
IUSE=""

# Needs to depend on 1.3 because this uses assert
# so we need -source 1.3 here.
RDEPEND=">=virtual/jre-1.3"
DEPEND=">=virtual/jdk-1.3
	app-arch/unzip"

src_unpack() {
	unpack ${A}

	cd "${S}/src"
	epatch "${FILESDIR}/${P}-buildfile.patch"

	cd "${S}/lib"
	rm -v *.jar || die
}

src_compile() {
	cd "${S}/src"
	java-pkg-2_src_compile
}

src_install() {
	java-pkg_dojar dist/${PN}.jar
	use doc && java-pkg_dojavadoc build/doc/javadoc
	use source && java-pkg_dosrc src/main/*
}
