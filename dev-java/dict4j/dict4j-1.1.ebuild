# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Dict protocol implementation in Java"
HOMEPAGE="http://dict4j.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-src.jar"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="doc source"

DEPEND=""

RDEPEND=">=virtual/jre-1.6
	${DEPEND}"
DEPEND=">=virtual/jdk-1.6
	app-arch/unzip
	${DEPEND}"

JAVA_SRC_DIR="net"
JAVA_ENCODING="ISO-8859-1"
