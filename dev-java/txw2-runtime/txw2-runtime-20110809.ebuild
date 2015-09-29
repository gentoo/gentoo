# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="${PN%%-*}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="TXW is a library that allows you to write XML documents"
HOMEPAGE="https://txw.dev.java.net/"
SRC_URI="http://central.maven.org/maven2/com/sun/xml/${MY_PN}/${MY_PN}/${PV}/${MY_P}-sources.jar"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86 ~x86-fbsd"
IUSE=""

DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

JAVA_SRC_DIR="com"
