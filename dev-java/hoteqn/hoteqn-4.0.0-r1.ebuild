# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java applet to view and display LaTeX mathematical equations"
HOMEPAGE="http://www.atp.ruhr-uni-bochum.de/VCLab/software/HotEqn/HotEqn.html"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
LICENSE="GPL-3"
SLOT=0
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos"
IUSE=""

RDEPEND="
	>=virtual/jre-1.6"

DEPEND="
	app-arch/unzip
	>=virtual/jdk-1.6"

JAVA_ENCODING="ISO-8859-1"

S="${WORKDIR}/${P}"

java_prepare() {
	rm -v mHotEqn.java || die
}

src_compile() {
	java-pkg-simple_src_compile
	java-pkg_addres "${PN}.jar" classes/ -name "*.gif"
}
