# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Traverses Java class file directories and generates design quality metrics"
HOMEPAGE="http://www.clarkware.com/software/JDepend.html"
SRC_URI="http://www.clarkware.com/software/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc64 x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	>=app-arch/unzip-5.50-r1"
RDEPEND=">=virtual/jre-1.4"

java_prepare() {
	rm -v "${S}"/lib/*.jar || die
}

src_install() {
	java-pkg_newjar dist/jdepend-2.9.jar
	dodoc README
	dohtml -r docs/*
	use doc && java-pkg_dojavadoc build/docs/api
	use source && java-pkg_dosrc src/*
}
