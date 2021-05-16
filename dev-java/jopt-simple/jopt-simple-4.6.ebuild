# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="A Java library for parsing command line options"
HOMEPAGE="https://pholser.github.com/jopt-simple/"
SRC_URI="https://github.com/pholser/${PN}/tarball/${P} -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="4.6"
KEYWORDS="amd64 ppc64 x86"

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"

JAVA_SRC_DIR="src/main/java"

S="${WORKDIR}/${PN}-${PN}-8808a39"

src_prepare() {
	default
	rm -v pom.xml || die
}

src_install() {
	default
	java-pkg-simple_src_install
}
