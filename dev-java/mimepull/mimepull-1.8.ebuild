# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Pull API for parsing MIME messages"
HOMEPAGE="http://java.net/projects/mimepull"
# svn export https://svn.java.net/svn/mimepull~svn/tags/mimepull-1.8 mimepull-1.8
# tar cjf mimepull-1.8.tar.bz2 mimepull-1.8
SRC_URI="https://dev.gentoo.org/~sera/distfiles/${P}.tar.bz2"

LICENSE="CDDL"
SLOT="0"
KEYWORDS="amd64 x86 ~x86-fbsd"
IUSE=""

RDEPEND="
	>=virtual/jre-1.5"
DEPEND="
	>=virtual/jdk-1.5
	test? ( dev-java/ant-junit:0 )"

java_prepare() {
	find -name '*.class' -exec rm -v {} + || die

	cp "${FILESDIR}"/${PN}-maven-build.xml build.xml || die
}

JAVA_ANT_REWRITE_CLASSPATH="yes"

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_dojar target/${PN}.jar

	use doc && java-pkg_dojavadoc target/site/apidocs
	use source && java-pkg_dosrc src/main/java/*
}
