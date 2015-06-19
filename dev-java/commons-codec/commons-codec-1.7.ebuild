# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/commons-codec/commons-codec-1.7.ebuild,v 1.6 2014/08/10 20:09:59 slyfox Exp $

EAPI=5
JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Implementations of common encoders and decoders in Java"
HOMEPAGE="http://commons.apache.org/codec"
SRC_URI="mirror://apache/commons/codec/source/${P}-src.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="test"

RDEPEND=">=virtual/jre-1.6"
DEPEND=">=virtual/jdk-1.6
	test? (
		dev-java/ant-junit:0
		dev-java/junit:4
	)"

S=${WORKDIR}/${P}-src

JAVA_ANT_ENCODING="ISO-8859-1"
EANT_TEST_GENTOO_CLASSPATH="junit-4"
JAVA_ANT_REWRITE_CLASSPATH="yes"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar dist/${P}*.jar

	dodoc RELEASE-NOTES.txt
	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/main/java/*
}
