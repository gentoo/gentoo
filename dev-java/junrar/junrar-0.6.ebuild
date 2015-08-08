# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="source doc"

inherit java-pkg-2 java-pkg-simple vcs-snapshot

DESCRIPTION="Unrar java implementation"
HOMEPAGE="https://github.com/edmund-wagner/junrar/"
SRC_URI="https://github.com/edmund-wagner/${PN}/archive/${P}.tar.gz"

LICENSE="unRAR"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="
	dev-java/commons-logging:0
	dev-java/commons-vfs:2"
RDEPEND="${CDEPEND}
	>=virtual/jre-1.5"
DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.5"

S="${WORKDIR}/${P}"

JAVA_GENTOO_CLASSPATH="commons-logging,commons-vfs-2"
JAVA_SRC_DIR="unrar/src/main/java"

java_prepare() {
	find -name "pom.xml" -delete || die
}
