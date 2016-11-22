# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A Java library for parsing command line options"
HOMEPAGE="https://pholser.github.com/jopt-simple/"
SRC_URI="https://github.com/pholser/${PN}/tarball/${P} -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

IUSE=""

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"

S="${WORKDIR}/pholser-${PN}-94ad77a"

JAVA_SRC_DIR="src/main/java"

java_prepare() {
	rm -v pom.xml || die
}

src_install() {
	java-pkg-simple_src_install
	dodoc README.md
}
