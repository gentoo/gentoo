# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Traverses Java class file directories and generates design quality metrics"
HOMEPAGE="https://github.com/clarkware/jdepend"
SRC_URI="https://github.com/clarkware/jdepend/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"

DEPEND=">=virtual/jdk-1.8:*"
RDEPEND=">=virtual/jre-1.8:*"

src_install() {
	java-pkg_newjar dist/jdepend-${PV}.jar
	dodoc README.md LICENSE.md ClassFileFormat-Java5.pdf
	docinto html
	dodoc -r docs/*
	use doc && java-pkg_dojavadoc build/docs/api
	use source && java-pkg_dosrc src/*
}
