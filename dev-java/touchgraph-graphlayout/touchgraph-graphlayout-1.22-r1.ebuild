# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="TGGraphLayout"

DESCRIPTION="TouchGraph provides a set of interfaces for graph visualization"
HOMEPAGE="http://touchgraph.sourceforge.net"
SRC_URI="mirror://sourceforge/touchgraph/TGGL_${PV//./}_jre11.zip"
LICENSE="Apache-1.1"
SLOT="0"
KEYWORDS="amd64 ppc ~ppc64 x86"
IUSE=""

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/${MY_PN}"

JAVA_SRC_DIR="com"

src_install() {
	java-pkg-simple_src_install
	dodoc "TGGL ReleaseNotes.txt"
}
