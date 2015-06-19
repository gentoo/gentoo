# Copyright 1999-2007 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/dtdparser/dtdparser-1.21-r1.ebuild,v 1.4 2007/06/01 06:47:15 betelgeuse Exp $

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A Java DTD Parser"
HOMEPAGE="http://www.wutka.com/dtdparser.html"
SRC_URI="http://www.wutka.com/download/${P}.tgz"

LICENSE="LGPL-2.1 Apache-1.1"
SLOT="${PV}"
KEYWORDS="amd64 ~ppc x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

src_unpack() {
	unpack ${A}
	cd "${S}"
	rm -v *.jar || die
	rm -v classes/com/wutka/dtd/*.class || die
	epatch "${FILESDIR}/buildfile.patch"
}

EANT_BUILD_TARGET="build"
EANT_DOC_TARGET="createdoc"

src_install() {
	java-pkg_dojar dist/${PN}.jar
	dodoc CHANGES README || die

	use doc && java-pkg_dojavadoc doc
	use source && java-pkg_dosrc source/*
}
