# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-opt-2 java-pkg-simple toolchain-funcs

DESCRIPTION="Protein multiple-alignment-based sequence annealing"
HOMEPAGE="https://wiki.gentoo.org/wiki/No_homepage"
SRC_URI="http://baboon.math.berkeley.edu/amap/download/${P/-/.}.tar.gz"
S="${WORKDIR}/amap-align"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="java"

DEPEND="java? ( >=virtual/jdk-1.8:* )"
RDEPEND="java? ( >=virtual/jre-1.8:* )"

DOCS=( align/{README,PROBCONS.README} )

PATCHES=(
	"${FILESDIR}"/${P}-makefile.patch
	"${FILESDIR}"/${P}-includes.patch
)

src_prepare() {
	default
	use java && java-pkg-opt-2_src_prepare && java-pkg_clean
}

src_configure() {
	tc-export CXX
}

src_compile() {
	emake -C align
	if use java; then
		JAVA_JAR_FILENAME="amapdisplay.jar"
		JAVA_SRC_DIR="display/src"
		java-pkg-simple_src_compile
	fi
}

src_install() {
	dobin align/${PN}

	insinto /usr/share/${PN}
	doins -r examples

	use java && java-pkg-simple_src_install
}
