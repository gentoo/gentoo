# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jackson-annotations/jackson-annotations-2.5.1.ebuild,v 1.1 2015/03/04 23:20:10 chewi Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="High-performance JSON processor"
HOMEPAGE="https://github.com/FasterXML/jackson-annotations"
SRC_URI="https://github.com/FasterXML/${PN}/archive/${PN}-${PV}.tar.gz"

LICENSE="Apache-2.0"
SLOT="2"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"

S="${WORKDIR}/${PN}-${P}/src"
JAVA_SRC_DIR="main/java"

src_install() {
	java-pkg-simple_src_install
	dodoc ../README.md ../release-notes/VERSION
}
