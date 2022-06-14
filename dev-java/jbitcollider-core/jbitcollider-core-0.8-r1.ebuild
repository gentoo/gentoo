# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

MY_PN="jBitcollider"
MY_P="${MY_PN}-${PV}"
JAVA_SRC_DIR="plugins/org.bitpedia.collider.core/src"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Core classes of jBitcollider: org.bitpedia.collider.core"
HOMEPAGE="http://bitcollider.sourceforge.net/"
SRC_URI="mirror://sourceforge/project/bitcollider/jBitcollider%20%28Java%29/${PV}/${MY_P}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 ~arm x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"
BDEPEND="app-arch/unzip"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	default

	rm -v lib/*.jar || die
	rm -v plugins/*/lib/*.jar || die
	rm -v plugins/org.bitpedia.collider.*/bin/org/bitpedia/collider/*/*.class || die
	rm -v plugins/org.bitpedia.collider.core/bin/org/bitpedia/util/*.class || die
	java-pkg-2_src_prepare
}
