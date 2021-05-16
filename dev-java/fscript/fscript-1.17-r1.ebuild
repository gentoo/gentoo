# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java based scripting engine designed to be embedded into other Java applications"
HOMEPAGE="http://fscript.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tgz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=virtual/jdk-1.4"
RDEPEND=">=virtual/jre-1.4"

java_prepare() {
	rm -v "${S}/FScript.jar" || die
}

EANT_DOC_TARGET="jdoc"

src_test() {
	eant test
}

src_install() {
	java-pkg_dojar *.jar

	dodoc CREDITS README VERSION
	# docs/* contains not only javadoc:
	use doc && java-pkg_dohtml -r docs/*
	use examples && java-pkg_doexamples examples/
	use source && java-pkg_dosrc src/*
}
