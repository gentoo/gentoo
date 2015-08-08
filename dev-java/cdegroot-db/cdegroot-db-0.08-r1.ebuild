# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="OO database written in Java"
HOMEPAGE="http://www.cdegroot.com/software/db/"
SRC_URI="http://www.cdegroot.com/software/db/download/com.${P/-/.}.tar.gz"

LICENSE="MIT"
SLOT="1"
KEYWORDS="amd64 x86 ppc64 ppc"
IUSE="doc source"

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

S=${WORKDIR}/com.${P/-/.}

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -rv src/db/test || die
	rm -v lib/*.jar || die

	cp "${FILESDIR}/build.xml" "${S}/build.xml"
	epatch "${FILESDIR}/${P}-gentoo.patch"
}

EANT_DOC_TARGET="docs"

src_install() {
	java-pkg_dojar dist/${PN}.jar

	dodoc TODO VERSION CHANGES BUGS README || die
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc src/*
}
