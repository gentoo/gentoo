# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jlibeps/jlibeps-0.1.ebuild,v 1.1 2014/01/03 21:59:35 mrueg Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="A java development library which allows the creation of an EPS file from a Graphics2D"
HOMEPAGE="http://jlibeps.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64"

IUSE=""

RDEPEND=">=virtual/jre-1.4"

DEPEND="app-arch/unzip
	>=virtual/jdk-1.4"

EANT_DOC_TARGET="doc"

S=${WORKDIR}

java_prepare() {
	epatch "${FILESDIR}"/${PN}-build.xml.patch
	find . -name '*.class' -exec rm -v {} + || die "Class removal failed"
}

src_install() {
	java-pkg_dojar out/${PN}.jar
	use doc && java-pkg_dojavadoc doc
	use source && java-pkg_dosrc src/org
}
