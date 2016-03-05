# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="an Apache ANT optional task that extracts snippets of code from text files"
HOMEPAGE="http://www.martiansoftware.com/lab/snip.html"
SRC_URI="http://www.martiansoftware.com/lab/${PN}/${P}-src.zip -> ${P}.zip"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~x86-solaris"
IUSE=""

CDEPEND="dev-java/ant-core:0"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6
	source? ( app-arch/zip )"

JAVA_GENTOO_CLASSPATH="ant-core"

java_prepare() {
	java-pkg_clean
}
