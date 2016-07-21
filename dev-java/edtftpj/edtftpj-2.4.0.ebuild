# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="FTP client library written in Java"
SRC_URI="http://www.enterprisedt.com/products/edtftpj/download/${P}.zip"
HOMEPAGE="http://enterprisedt.com/products/edtftpnet"
LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="examples"

DEPEND=">=virtual/jdk-1.7
	app-arch/unzip"

RDEPEND=">=virtual/jre-1.7"

EANT_DOC_TARGET="javadocs"
EANT_BUILD_XML="src/build.xml"

java_prepare() {
	java-pkg_clean

	# Tests are geared for Windows and sit in the main sources.
	rm -rv src/com/enterprisedt/net/ftp/test || die

	# Delete Windows .bat files.
	find -name "*.bat" -delete || die

	# Adjust doc URLs to match our layout.
	find examples -name "*.html" -exec sed -i 's:/doc/manual/:/manual/:g' {} + || die
}

src_install() {
	java-pkg_dojar lib/${PN}.jar

	use doc && java-pkg_dojavadoc build/doc/api
	use source && java-pkg_dosrc src/*

	docinto html
	use doc && dodoc -r doc/manual
	use examples && dodoc -r examples
}
