# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Open-source graph component for Java"
SRC_URI="mirror://gentoo/${P}.jar"
HOMEPAGE="https://www.jgraph.com"
IUSE="doc examples source"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 x86"

DEPEND="
	>=virtual/jdk-1.8"

RDEPEND="
	>=virtual/jre-1.8"

DOCS=( README WHATSNEW LICENSE ChangeLog )

S="${WORKDIR}"

JAVA_SRC_DIR="src"

src_prepare() {
	default

	java-pkg_clean
}
