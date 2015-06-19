# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/cssparser/cssparser-0.9.14.ebuild,v 1.5 2015/05/27 08:31:32 monsieurp Exp $
EAPI="5"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="API for parsing CSS 2 in Java"
HOMEPAGE="http://cssparser.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}-sources.jar"
LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

CDEPEND="dev-java/sac:0"
DEPEND=">=virtual/jdk-1.5
	${CDEPEND}"
RDEPEND=">=virtual/jre-1.5
	${CDEPEND}"

JAVA_GENTOO_CLASSPATH="sac"
