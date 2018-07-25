# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="LzmaInputStream/LzmaOutputStream interacting with underlying LZMA en-/decoders"
HOMEPAGE="https://contrapunctus.net/league/haques/lzmajio/
	https://github.com/league/lzmajio"
SRC_URI="https://github.com/league/${P}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CDEPEND="dev-java/lzma:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6"

S="${WORKDIR}/${P}"

JAVA_GENTOO_CLASSPATH="lzma"
JAVA_SRC_DIR="net"
