# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/lzmajio/lzmajio-0.95.ebuild,v 1.4 2012/06/04 08:22:51 johu Exp $

EAPI=2
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Implementations of LzmaInputStream/LzmaOutputStream interacting with underlying LZMA en-/decoders"
HOMEPAGE="http://contrapunctus.net/league/haques/lzmajio/"
SRC_URI="http://comsci.liu.edu/~league/dist/${PN}/${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

IUSE=""

COMMON_DEP=">=dev-java/lzma-4.61"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.5
	app-arch/unzip
	${COMMON_DEP}"

EANT_GENTOO_CLASSPATH="lzma"

src_prepare() {
	java-pkg_jar-from lzma
}

src_install() {
	java-pkg_dojar ${PN}.jar
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc net
}
