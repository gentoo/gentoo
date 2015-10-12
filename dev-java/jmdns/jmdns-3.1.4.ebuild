# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JmDNS is an implementation of multi-cast DNS in Java"
SRC_URI="mirror://sourceforge/${PN}/${PF}.tgz"
HOMEPAGE="http://jmdns.sourceforge.net"

LICENSE="Apache-2.0"
SLOT="3.1"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/${P}"
JAVA_SRC_DIR="src"

src_prepare() {
	rm "${S}"/build.xml
	rm "${S}"/lib/*.jar || die
}
