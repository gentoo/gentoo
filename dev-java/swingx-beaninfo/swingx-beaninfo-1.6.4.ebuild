# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="SwingX Beaninfo"
HOMEPAGE="https://java.net/projects/swingx/"
SRC_URI="https://java.net/downloads/swingx/releases/${P}-sources.jar"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/swingx:1.6"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	${CDEPEND}
	app-arch/unzip"

JAVA_GENTOO_CLASSPATH="swingx-1.6"

src_compile() {
	java-pkg-simple_src_compile
	java-pkg_addres ${PN}.jar .
}
