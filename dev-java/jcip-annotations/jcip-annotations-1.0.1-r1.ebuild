# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

MY_P="${PN}-$(ver_rs 2 -)"

DESCRIPTION="Clean room implementation of the JCIP Annotations"
HOMEPAGE="https://github.com/stephenc/jcip-annotations"
SRC_URI="https://github.com/stephenc/${PN}/archive/${MY_P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=">=virtual/jre-1.8:*"
DEPEND=">=virtual/jdk-1.8:*"

S="${WORKDIR}/${PN}-${MY_P}/src"
JAVA_SRC_DIR="main/java"

src_install() {
	java-pkg-simple_src_install
	dodoc ../README.md
}
