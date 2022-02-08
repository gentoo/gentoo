# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Command line parsing framework for Java"
HOMEPAGE="https://github.com/cbeust/jcommander"
SRC_URI="https://github.com/cbeust/${PN}/archive/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ~ppc64 x86"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

S="${WORKDIR}/${PN}-${P}"

RESTRICT="test"

src_prepare() {
	default

	rm -rf src/test || die
}
