# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

COMMIT="33d17845e34c7c8b897224d0d1c243951398f853"
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="UPnP port mapping library for Java based on sbbi-upnplib"
HOMEPAGE="https://github.com/RPTools/upnplib"
SRC_URI="https://github.com/RPTools/upnplib/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
LICENSE="LGPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/commons-jxpath:0
	dev-java/log4j:0"

RDEPEND=">=virtual/jre-1.7
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.7
	${CDEPEND}"

JAVA_GENTOO_CLASSPATH="commons-jxpath,log4j"
JAVA_SRC_DIR="src"

S="${WORKDIR}/${PN}-${COMMIT}"

java_prepare() {
	# mx4j has been last-rited.
	rm -rv src/net/sbbi/upnp/jmx/ || die
}

src_install() {
	java-pkg-simple_src_install
	use doc && dodoc README.md docs/html/*.pdf
}
