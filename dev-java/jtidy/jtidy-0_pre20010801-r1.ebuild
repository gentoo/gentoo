# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit eutils base java-pkg-2 java-ant-2

MY_PV="04aug2000r7"
DESCRIPTION="Tidy is a Java port of HTML Tidy , a HTML syntax checker and pretty printer"
HOMEPAGE="http://jtidy.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${PN}-${MY_PV}-dev.zip"
LICENSE="HTML-Tidy W3C"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	dev-java/ant-core"
RDEPEND=">=virtual/jre-1.4"

S=${WORKDIR}/${PN}-${MY_PV}-dev

PATCHES=( "${FILESDIR}"/${PN}-source-1.4.patch )

src_compile() {
	eant jar # Has javadoc premade
}

src_install() {
	java-pkg_dojar build/Tidy.jar

	use doc && java-pkg_dojavadoc doc/api
	use source && java-pkg_dosrc src/org
}
