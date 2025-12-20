# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="100% Pure Java Regular Expression package"
HOMEPAGE="https://jakarta.apache.org/"
SRC_URI="mirror://apache/jakarta/regexp/source/${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="Apache-1.1"
SLOT="${PV}"
KEYWORDS="amd64 arm64 ppc64"

DEPEND="<virtual/jdk-26:*" # bug #965859
RDEPEND=">=virtual/jre-1.8:*"

JAVA_SRC_DIR="src/java"

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_clean
}
