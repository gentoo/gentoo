# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-java/junit/junit-4.12.ebuild,v 1.2 2015/07/12 12:19:16 monsieurp Exp $

EAPI="5"

JAVA_PKG_IUSE="doc examples source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Simple framework to write repeatable tests"
SRC_URI="https://github.com/${PN}-team/${PN}/archive/r${PV}.zip"
HOMEPAGE="http://www.junit.org/"

LICENSE="CPL-1.0"
SLOT="4"

KEYWORDS="~amd64 ~ppc ~ppc64 ~x86 ~amd64-fbsd ~x86-fbsd ~x64-freebsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris ~x64-solaris ~x86-solaris"

CDEPEND="dev-java/hamcrest-core:1.3"

RDEPEND=">=virtual/jre-1.6
	${CDEPEND}"

DEPEND=">=virtual/jdk-1.6
	userland_GNU? ( >=sys-apps/findutils-4.3 )
	${CDEPEND}"

S="${WORKDIR}/${PN}-r${PV}"

JAVA_ANT_REWRITE_CLASSPATH="yes"
EANT_BUILD_XML="build.xml"
EANT_DOC_TARGET="javadoc"

java_prepare() {
	cp "${FILESDIR}"/${P}-build.xml build.xml

	find . -type f \( -name \*.jar -o -name \*.class \) -print -delete

	java-pkg_jar-from --into lib hamcrest-core-1.3 hamcrest-core.jar
}

EANT_BUILD_TARGET="package"

src_compile() {
	java-pkg-2_src_compile
}

EANT_TEST_TARGET="test"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar target/${P}.jar junit.jar
	dodoc doc/ReleaseNotes${PV}.md

	if use examples; then
		java-pkg_doexamples src/test/java/org/junit/samples
	fi

	if use source; then
		java-pkg_dosrc src/main/java/{org,junit}
	fi

	if use doc; then
		java-pkg_dojavadoc target/site/apidocs
	fi
}
