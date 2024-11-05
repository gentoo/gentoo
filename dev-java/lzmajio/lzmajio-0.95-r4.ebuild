# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="LzmaInputStream/LzmaOutputStream interacting with underlying LZMA en-/decoders"
HOMEPAGE="https://contrapunctus.net/league/haques/lzmajio/
	https://github.com/league/lzmajio"
SRC_URI="https://github.com/league/lzmajio/archive/${PV}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${P}"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm64"

CP_DEPEND="dev-java/lzma:0"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*
"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
"

JAVA_SRC_DIR="net"
