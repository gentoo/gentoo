# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

JAVA_PKG_IUSE="doc source"

inherit eutils java-pkg-2 java-ant-2

DESCRIPTION="Java, open-source library for treemapping"
HOMEPAGE="http://jtreemap.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.zip"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE=""
RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip"

S="${WORKDIR}/${PN}-site-${PV}/JTreeMap"
EANT_BUILD_TARGET="buildJar"

src_unpack() {
	unpack ${A}
	epatch "${FILESDIR}"/${P}-build.xml.patch
	einfo "Removing bundled jars."
	find . -name "*.jar" -print -delete
}

src_install() {
	java-pkg_dojar ${PN}.jar
	use doc && java-pkg_dojavadoc doc
	java-pkg_dolauncher ${PN}-demo --main net.sf.jtreemap.swing.example.JTreeMapExample
	use source && java-pkg_dosrc src/main/java/net
}
