# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/stringtemplate/stringtemplate-3.2.ebuild,v 1.10 2013/02/05 07:00:10 zerochaos Exp $

EAPI="2"
JAVA_PKG_IUSE="doc source"
WANT_ANT_TASKS="ant-antlr"

inherit eutils java-pkg-2 java-ant-2

MY_PV="${PV/_beta/b}"
S_PV="${PV/_beta/.b}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A Java template engine"
HOMEPAGE="http://www.stringtemplate.org/"
SRC_URI="http://www.stringtemplate.org/download/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 x86 ~amd64-linux ~x86-linux ~x86-solaris"
IUSE=""

# no junit targets in build.xml, but unconditional compile and jar of test
# classes, oh well
COMMON_DEPEND=">=dev-java/antlr-2.7.7:0[java]
	dev-java/junit:0"

RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-1.4
	${COMMON_DEPEND}"

S="${WORKDIR}/${PN}-${S_PV}"

java_prepare() {
	# fix <javadoc> call
	epatch "${FILESDIR}/${PN}-3.1_beta1-javadoc.patch"
	java-ant_rewrite-classpath
	rm -v lib/*.jar || die
	# force regeneration with our antlr2
	touch src/org/antlr/stringtemplate/language/*.g || die
}

EANT_GENTOO_CLASSPATH="antlr,junit"
EANT_DOC_TARGET="javadocs"

src_install() {
	java-pkg_dojar build/${PN}.jar

	dodoc README.txt CHANGES.txt || die
	use doc && java-pkg_dojavadoc docs/api
	use source && java-pkg_dosrc src/org
}
