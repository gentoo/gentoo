# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Set of tools for processing XML documents"
HOMEPAGE="https://www.saxonica.com/index.html https://saxon.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/saxon/saxon6/${PV}/saxon${PV//./-}.zip"

LICENSE="MPL-1.1"
SLOT="6.5"
KEYWORDS="amd64 x86"

CP_DEPEND="dev-java/jdom:0"

# Restricting to jdk:1.8 for following reason:
# src/org/w3c/dom/UserDataHandler.java:1: error: package exists in another module: java.xml
# package org.w3c.dom;
DEPEND="${CP_DEPEND}
	virtual/jdk:1.8"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

BDEPEND="app-arch/unzip"

JAVA_ENCODING="ISO-8859-1"
JAVA_SRC_DIR="src"

src_unpack() {
	unpack ${A}
	unzip -qq source.zip -d src || die "failed to unpack"
}

src_prepare() {
	default
	java-pkg_clean
}

src_install() {
	default
	java-pkg-simple_src_install
	use examples && java-pkg_doexamples samples
}
