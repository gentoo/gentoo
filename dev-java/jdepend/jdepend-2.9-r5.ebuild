# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/jdepend/jdepend-2.9-r5.ebuild,v 1.5 2015/05/17 20:06:15 pacho Exp $

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="JDepend traverses Java class file directories and generates design quality metrics per package"
HOMEPAGE="http://www.clarkware.com/software/JDepend.html"
SRC_URI="http://www.clarkware.com/software/${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

DEPEND=">=virtual/jdk-1.4
	>=app-arch/unzip-5.50-r1"
RDEPEND=">=virtual/jre-1.4"

java_prepare() {
	rm -v "${S}"/lib/*.jar || die
}

src_install() {
	java-pkg_newjar dist/jdepend-2.9.jar
	dodoc README || die
	dohtml -r docs/* || die
	use doc && java-pkg_dojavadoc build/docs/api
	use source && java-pkg_dosrc src/*
}
