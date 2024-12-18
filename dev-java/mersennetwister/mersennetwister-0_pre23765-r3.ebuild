# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Modified MersenneTwister java port for Freenet"
HOMEPAGE="http://www.math.sci.hiroshima-u.ac.jp/~m-mat/MT/emt.html"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm64"

DEPEND="
	source? ( app-arch/zip )
	>=virtual/jdk-1.8:*
"

RDEPEND=">=virtual/jre-1.8:*"
