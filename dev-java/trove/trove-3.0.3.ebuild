# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_PN="${PN}4j"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="GNU Trove: High performance collections for Java"
SRC_URI="https://repo1.maven.org/maven2/net/sf/${MY_PN}/${MY_PN}/${PV}/${MY_P}-sources.jar -> ${P}.jar"
HOMEPAGE="http://trove4j.sourceforge.net"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~ppc-macos"

SLOT="0"
LICENSE="LGPL-2.1"

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	>=virtual/jdk-1.6"

src_prepare() {
	default
	rm -v gnu/trove/impl/package.html || die
}
