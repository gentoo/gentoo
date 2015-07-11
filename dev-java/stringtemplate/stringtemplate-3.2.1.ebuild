# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/stringtemplate/stringtemplate-3.2.1.ebuild,v 1.5 2015/07/11 09:22:33 chewi Exp $

EAPI="2"
JAVA_PKG_IUSE="doc source test"

inherit eutils java-pkg-2 java-ant-2

MY_PV="${PV/_beta/b}"
S_PV="${PV/_beta/.b}"
MY_P="${PN}-${MY_PV}"

DESCRIPTION="A Java template engine"
HOMEPAGE="http://www.stringtemplate.org/"
SRC_URI="http://www.stringtemplate.org/download/${MY_P}.tar.gz"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~ppc ~ppc64 ~x86 ~amd64-linux ~x86-linux ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE=""

COMMON_DEPEND=">=dev-java/antlr-2.7.7:0[java]"

RDEPEND=">=virtual/jre-1.5
	${COMMON_DEPEND}"

DEPEND=">=virtual/jdk-1.5
	test? ( dev-java/junit:4 )
	${COMMON_DEPEND}"

S="${WORKDIR}/${PN}-${S_PV}"

java_prepare() {
	find . -name "*.class" -print -delete || die "Failed deleting precompiled classes"
	find . -name "*.jar" -print -delete || die "Failed deleting prebuilt classes"
}

antlr2() {
	java -cp $(java-pkg_getjars antlr) antlr.Tool "${@}" || die "antlr2 failed"
}

src_compile() {
	einfo "Generate from grammars"
	cd src/org/antlr/stringtemplate/language || die
	# order same as in pom.xml
	antlr2 template.g
	antlr2 angle.bracket.template.g
	antlr2 action.g
	antlr2 eval.g
	antlr2 group.g
	antlr2 interface.g

	cd "${S}" || die
	find src -name "*.java" >> "${T}/sources" || die
	ejavac -d target/classes -cp $(java-pkg_getjars antlr) "@${T}/sources"

	# create javadoc
	if use doc; then
		javadoc -classpath $(java-pkg_getjars antlr) -d javadoc "@${T}/sources" || die "Javadoc failed"
	fi

	# jar things up
	cd target/classes || die
	find -type f >> "${T}/classes" || die
	jar cf ${PN}.jar "@${T}/classes" || die "jar failed"
}

src_install() {
	java-pkg_dojar target/classes/${PN}.jar
	dodoc README.txt CHANGES.txt || die
	use source && java-pkg_dosrc src/*
	use doc && java-pkg_dojavadoc javadoc
}

src_test() {
	find test -name "*.java" >> "${T}/test-sources" || die
	ejavac -cp target/classes:$(java-pkg_getjars antlr,junit-4) -d target/test-classes "@${T}/test-sources"
	ejunit4 -cp target/classes:target/test-classes org.antlr.stringtemplate.test.TestStringTemplate
}
