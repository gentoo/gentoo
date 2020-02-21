# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java command line option parser"
HOMEPAGE="http://www.urbanophile.com/arenn/hacking/download.html"
SRC_URI="http://www.urbanophile.com/arenn/hacking/getopt/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="1"
KEYWORDS="amd64 ~arm ~arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

S="${WORKDIR}"

java_prepare() {
	mv gnu/getopt/buildx.xml build.xml || die
}

src_install() {
	java-pkg_dojar build/lib/gnu.getopt.jar
	dodoc gnu/getopt/COPYING.LIB gnu/getopt/ChangeLog gnu/getopt/README
	use doc && java-pkg_dojavadoc build/api
	use source && java-pkg_dosrc gnu
}
