# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A minimalistic realtime charting library for Java"
HOMEPAGE="http://jchart2d.sourceforge.net"
SRC_URI="mirror://sourceforge/${PN}/${PN}/sources/${PN}-eclipse-project-${PV}.zip"
LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test" # Even the headless tests need a display!?

CDEPEND="dev-java/jide-oss:0
	dev-java/xmlgraphics-commons:2"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	${CDEPEND}
	app-arch/unzip"

JAVA_GENTOO_CLASSPATH="jide-oss,xmlgraphics-commons-2"
JAVA_SRC_DIR="src"

S="${WORKDIR}/${PN}"

java_prepare() {
	rm -rv ext/* || die

	# Ant tries and fails to build these outdated bug
	# demonstrations. Did Ant's globbing behaviour change?
	rm -v src/*.java || die
}
