# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="${PN}-jdk15on"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Java cryptography APIs"
HOMEPAGE="http://www.bouncycastle.org/java.html"
SRC_URI="http://central.maven.org/maven2/org/bouncycastle/${MY_PN}/${PV}/${MY_P}-sources.jar"

KEYWORDS="amd64 ppc64 x86 ~amd64-fbsd ~x86-fbsd ~amd64-linux ~x86-linux ~x64-macos"

LICENSE="BSD"
SLOT="1.50"

CDEPEND="dev-java/bcprov:${SLOT}"

DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${CDEPEND}"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

JAVA_GENTOO_CLASSPATH="bcprov-${SLOT}"
JAVA_ENCODING="ISO-8859-1"
JAVA_SRC_DIR="org"
