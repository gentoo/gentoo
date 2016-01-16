# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="XP is an XML 1.0 parser written in Java"
HOMEPAGE="http://www.jclark.com/xml/xp"
SRC_URI="ftp://ftp.jclark.com/pub/xml/xp.zip"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}"

java_prepare() {
	rm -v xp.jar || die
	cp "${FILESDIR}/build.xml" . || die
	epatch "${FILESDIR}"/${PV}-*.patch
}

#premade javadocs
EANT_DOC_TARGET=""

src_install() {
	java-pkg_dojar xp.jar
	dodoc docs/copying.txt
	#has index.html and javadocs here
	use doc && java-pkg_dohtml -r docs/*
	use source && java-pkg_dosrc com
}
