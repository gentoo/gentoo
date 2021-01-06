# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source examples"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="JZlib is a re-implementation of zlib in pure Java"
HOMEPAGE="http://www.jcraft.com/jzlib/"
SRC_URI="http://www.jcraft.com/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

BDEPEND="source? ( app-arch/zip )"
RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="com"

src_install() {
	java-pkg-simple_src_install
	dodoc README ChangeLog
	use examples && java-pkg_doexamples example
}
