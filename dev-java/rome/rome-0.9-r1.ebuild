# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Open source Atom/RSS Java utilities that make it easy to work in Java with most syndication formats"
HOMEPAGE="https://java.net/projects/rome"
SRC_URI="https://rome.dev.java.net/source/browse/*checkout*/rome/www/dist/${P}-src.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd"
IUSE=""

COMMON_DEPEND="dev-java/jdom:0"
DEPEND=">=virtual/jdk-1.4
	app-arch/unzip
	test? ( dev-java/ant-junit:0 )
	${COMMON_DEPEND}"
RDEPEND=">=virtual/jre-1.4
	${COMMON_DEPEND}"

JAVA_ANT_REWRITE_CLASSPATH="true"
EANT_GENTOO_CLASSPATH="jdom"

java_prepare() {
	# Patch build.xml so the tests pass
	epatch "${FILESDIR}/${P}-build.xml-test-upstream.patch"

	# Keep Ant happy.
	mkdir -p target/lib || die
}

src_install() {
	java-pkg_newjar target/${P}.jar

	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/*
}

src_test() {
	java-pkg-2_src_test
}
