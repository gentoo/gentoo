# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Provides faster type-specific maps, sets and lists with a small memory footprint"
HOMEPAGE="https://github.com/vigna/fastutil"
SRC_URI="https://github.com/vigna/fastutil/archive/${PV}.zip -> ${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc64 x86"

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6"

src_compile() {
	emake sources

	# bug 162650 and #175578
	java-pkg_init-compiler_

	[[ ${GENTOO_COMPILER} != "javac" ]] && export ANT_OPTS="-Xmx512m"
	java-pkg-2_src_compile
}

src_install() {
	java-pkg_newjar "${P}.jar"

	dodoc CHANGES README.md

	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc src/it
}
