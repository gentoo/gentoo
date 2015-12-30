# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Docking solution for Java Swing"
HOMEPAGE="https://github.com/cmadsen/vldocking"
SRC_URI="https://github.com/cmadsen/${PN}/archive/${P}.zip"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

CDEPEND="
	dev-java/slf4j-log4j12:0
	dev-java/slf4j-api:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	app-arch/unzip
	>=virtual/jdk-1.6"

JAVA_GENTOO_CLASSPATH="
	slf4j-log4j12
	slf4j-api
"

java_prepare() {
	java-pkg_clean
}
