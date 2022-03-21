# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="100% Pure Java Regular Expression package"
SRC_URI="mirror://apache/jakarta/regexp/source/${P}.tar.gz"
HOMEPAGE="https://jakarta.apache.org/"

SLOT="${PV}"
IUSE=""
LICENSE="Apache-1.1"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-solaris"

RDEPEND="
	>=virtual/jre-1.8:*"

DEPEND="
	>=virtual/jdk-1.8:*"

S="${WORKDIR}/${P}"

JAVA_SRC_DIR="src/java"

src_prepare() {
	default
	java-pkg_clean
}
