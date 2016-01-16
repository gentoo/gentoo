# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="FTP client library written in Java"
SRC_URI="http://www.enterprisedt.com/products/edtftpj/download/${P}.zip"
HOMEPAGE="http://www.enterprisedt.com"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND=">=virtual/jre-1.4
	=dev-java/junit-3.8*"

DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	${RDEPEND}"

java_prepare() {
	find . '(' -name '*.class' -o -name '*.jar' ')' -print -delete

	rm doc/LICENSE.TXT || die "Failed to remove LICENSE.TXT"
}

src_compile() {
	cd src || die

	eant jar -Dftp.classpath=$(java-pkg_getjars junit) $(use_doc javadocs)
}

src_install() {
	java-pkg_dojar lib/*.jar

	use doc && java-pkg_dojavadoc build/doc/api
	use source && java-pkg_dosrc src/com
	use examples && java-pkg_doexamples examples
}
