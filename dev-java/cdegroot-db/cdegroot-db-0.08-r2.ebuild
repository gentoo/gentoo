# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="OO database written in Java"
HOMEPAGE="http://www.cdegroot.com/software/db/"
SRC_URI="http://www.cdegroot.com/software/db/download/com.${P/-/.}.tar.gz"

LICENSE="MIT"
SLOT="1"
KEYWORDS="amd64 ppc64 x86"
IUSE="doc source"

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}/com.${P/-/.}"

PATCHES=( "${FILESDIR}/${P}-gentoo.patch" )
src_prepare() {
	default
	rm -rv src/db/test lib/*.jar || die
	cp -v "${FILESDIR}/build.xml" "${S}/build.xml" || die
}

EANT_DOC_TARGET="docs"

src_install() {
	java-pkg_dojar "dist/${PN}.jar"
	dodoc TODO VERSION CHANGES BUGS README
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc src/*
}
