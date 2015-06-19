# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jopt-simple/jopt-simple-4.4.ebuild,v 1.1 2013/09/13 16:29:43 ercpe Exp $

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit vcs-snapshot java-pkg-2 java-pkg-simple

DESCRIPTION="A Java library for parsing command line options"
HOMEPAGE="http://pholser.github.com/jopt-simple/"
SRC_URI="https://github.com/pholser/${PN}/tarball/${P} -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="4.4"
KEYWORDS="~amd64 ~x86"

IUSE=""

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"

S="${WORKDIR}/${P}"
JAVA_SRC_DIR="src/main/java"

java_prepare() {
	# Easier to use java-pkg-simple.
	rm -v pom.xml || die
}

src_install() {
	java-pkg-simple_src_install
	dodoc README.md
}
