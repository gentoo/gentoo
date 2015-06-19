# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jmdns/jmdns-3.4.1.ebuild,v 1.4 2014/08/10 20:18:21 slyfox Exp $

EAPI="5"

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JmDNS is an implementation of multi-cast DNS in Java"
SRC_URI="mirror://sourceforge/${PN}/${PF}.tgz"
HOMEPAGE="http://jmdns.sourceforge.net"

LICENSE="Apache-2.0"
SLOT="3.4"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}"
JAVA_SRC_DIR="src"

src_prepare() {
	rm "${S}"/build.xml || die
	find -name "*.jar" -delete || die
	find "${JAVA_SRC_DIR}" -name "*Test.java" -delete || die
}
