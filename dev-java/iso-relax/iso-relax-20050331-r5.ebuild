# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Interfaces useful for applications which support RELAX Core"
HOMEPAGE="http://www.xml.gr.jp/relax/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

RESTRICT="test"

CDEPEND="dev-java/ant-core:0"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.8:*"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8:*"

S="${WORKDIR}/${P}"

JAVA_GENTOO_CLASSPATH="ant-core"

JAVA_SRC_DIR="src"

src_prepare() {
	default
	java-pkg_clean
}
