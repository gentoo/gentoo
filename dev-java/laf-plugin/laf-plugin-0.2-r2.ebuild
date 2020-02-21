# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Look'n'feel Java library"
HOMEPAGE="http://laf-plugin.dev.java.net/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

KEYWORDS="amd64 x86"
SLOT="0"
LICENSE="BSD"

DEPEND=">=virtual/jdk-1.6"
RDEPEND=">=virtual/jre-1.6"

S="${WORKDIR}/${P}"

PATCHES=( "${FILESDIR}/${P}-enum.patch" )

src_prepare() {
	default
}

src_install() {
	java-pkg-simple_src_install
}
