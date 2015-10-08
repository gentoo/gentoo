# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$
EAPI="5"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="API for parsing CSS 2 in Java"
HOMEPAGE="http://cssparser.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-sources.jar"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

CDEPEND="dev-java/sac:0"
DEPEND=">=virtual/jdk-1.6
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

JAVA_GENTOO_CLASSPATH="sac"
