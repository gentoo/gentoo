# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2 eutils

DESCRIPTION="A simple HTML scanner and tag balancer using standard XML interfaces"

HOMEPAGE="http://nekohtml.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="Apache-2.0"

SLOT="0"
KEYWORDS="amd64 x86"

COMMON_DEP=">=dev-java/xerces-2.7"
DEPEND=">=virtual/jdk-1.4
	test? (
		dev-java/junit:0
		dev-java/ant-junit:0
	)
	${COMMON_DEP}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEP}"

JAVA_ANT_CLASSPATH_TAGS="${JAVA_ANT_CLASSPATH_TAGS} taskdef"
JAVA_ANT_REWRITE_CLASSPATH="yes"

EANT_GENTOO_CLASSPATH="xerces-2"
EANT_TEST_GENTOO_CLASSPATH="ant-junit,junit,xerces-2"

# Do not generate docs, use bundled.
EANT_DOC_TARGET=""

java_prepare() {
	find . -iname '*.jar' -delete || die
	epatch "${FILESDIR}"/${P}-remove-obsolete-xerces-bridges.patch
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar build/lib/${PN}.jar

	if use doc; then
		java-pkg_dojavadoc doc/javadoc
		java-pkg_dohtml -r doc/*
	fi

	use source && java-pkg_dosrc src/org
	use examples && java-pkg_doexamples src/sample
}
