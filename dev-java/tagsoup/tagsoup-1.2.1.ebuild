# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A SAX-compliant parser written in Java"
HOMEPAGE="http://mercury.ccil.org/~cowan/XML/tagsoup/"
SRC_URI="http://mercury.ccil.org/~cowan/XML/tagsoup/${P}-src.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm arm64 ppc64 x86 ~amd64-linux ~x86-linux ~x86-macos"

BDEPEND="app-arch/unzip"
RDEPEND="
	>=virtual/jre-1.4"
DEPEND="
	dev-java/saxon:9
	>=virtual/jdk-1.4"

EANT_BUILD_TARGET="dist"
EANT_DOC_TARGET="docs-api"
# Fails to detect a TransformerFactory. #421733
# See also https://issues.apache.org/jira/browse/XALANJ-1549 for why the default is no good either.
EANT_ANT_TASKS="saxon-9"
EANT_EXTRA_ARGS="-Dtransformer.factory=net.sf.saxon.TransformerFactoryImpl"

src_install() {
	java-pkg_newjar dist/lib/${PN}-1.2.jar ${PN}.jar
	java-pkg_dolauncher

	doman ${PN}.1
	dodoc CHANGES README TODO

	use doc && java-pkg_dojavadoc docs/api
	use source && java-pkg_dosrc src/{java,templates}/*
}
