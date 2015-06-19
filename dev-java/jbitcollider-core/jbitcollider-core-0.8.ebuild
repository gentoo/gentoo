# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jbitcollider-core/jbitcollider-core-0.8.ebuild,v 1.4 2012/03/24 17:24:05 phajdan.jr Exp $

EAPI=4
JAVA_PKG_IUSE="doc source"

MY_PN="jBitcollider"
MY_P="${MY_PN}-${PV}"
JAVA_SRC_DIR="plugins/org.bitpedia.collider.core/src"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Core classes of jBitcollider: org.bitpedia.collider.core"
HOMEPAGE="http://bitcollider.sourceforge.net/"
SRC_URI="mirror://sourceforge/bitcollider/${MY_P}.zip"

LICENSE="public-domain"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"

S="${WORKDIR}/${MY_P}"

src_prepare() {
	rm -v lib/*.jar || die
	rm -v plugins/*/lib/*.jar || die
	rm -v plugins/org.bitpedia.collider.*/bin/org/bitpedia/collider/*/*.class || die
	rm -v plugins/org.bitpedia.collider.core/bin/org/bitpedia/util/*.class || die
	java-pkg-2_src_prepare
}
