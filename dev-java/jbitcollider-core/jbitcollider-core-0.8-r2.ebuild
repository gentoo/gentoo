# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

MY_PN="jBitcollider"
MY_P="${MY_PN}-${PV}"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Core classes of jBitcollider: org.bitpedia.collider.core"
HOMEPAGE="https://bitcollider.sourceforge.net"
SRC_URI="https://downloads.sourceforge.net/project/bitcollider/jBitcollider%20%28Java%29/${PV}/${MY_P}.zip"
S="${WORKDIR}/${MY_P}"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/unzip"

JAVA_SRC_DIR="plugins/org.bitpedia.collider.core/src"

src_prepare() {
	java-pkg-2_src_prepare
	java-pkg_clean
}
