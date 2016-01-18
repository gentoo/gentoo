# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="cglib is a powerful, high performance and quality Code Generation Library"
HOMEPAGE="https://github.com/cglib/cglib"
SRC_URI="mirror://sourceforge/${PN}/${PN}-src-${PV}.jar"

LICENSE="Apache-2.0"
SLOT="3"
KEYWORDS="amd64 ppc64 x86"

IUSE=""

COMMON_DEP="dev-java/asm:4
	dev-java/ant-core:0"
RDEPEND=">=virtual/jre-1.6
	${COMMON_DEP}"
DEPEND=">=virtual/jdk-1.6
	test? ( dev-java/junit:4 )
	${COMMON_DEP}"

S="${WORKDIR}"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_GENTOO_CLASSPATH="asm-4 ant-core"

java_prepare() {
	find . -iname '*.jar' -delete || die

	# Get rid of some parts in XML.
	epatch "${FILESDIR}"/${P}-build.xml.patch
}

src_install() {
	java-pkg_newjar dist/${P}.jar ${PN}.jar

	if use doc; then
		java-pkg_dojavadoc docs
	fi

	if use source; then
		java-pkg_dosrc src/proxy/net
	fi

	if use examples; then
		java-pkg_doexamples --subdir samples src/proxy/samples
	fi
}

src_test() {
	java-pkg-2_src_test
}
