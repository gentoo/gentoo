# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="5"
JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JmDNS is an implementation of multi-cast DNS in Java"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"
HOMEPAGE="http://jmdns.sourceforge.net"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc64 x86"
IUSE=""

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

JAVA_SRC_DIR="src"

src_prepare() {
	rm "${S}"/build.xml || die
	find -name "*.jar" -delete || die
	find "${JAVA_SRC_DIR}" -name "*Test.java" -delete || die
}
