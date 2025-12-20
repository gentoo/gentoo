# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Interfaces useful for applications which support RELAX Core"
HOMEPAGE="http://www.xml.gr.jp/relax/"
SRC_URI="mirror://gentoo/${P}.tar.bz2"
S="${WORKDIR}/${P}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 arm64 ppc64 ~x64-solaris"

CP_DEPEND=">=dev-java/ant-1.10.14-r3:0"
DEPEND="${CP_DEPEND}
	>=virtual/jdk-1.8:*"
RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

JAVA_SRC_DIR="src"

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_clean
}
