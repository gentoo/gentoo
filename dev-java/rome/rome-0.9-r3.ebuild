# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

JAVA_PKG_IUSE="doc source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Java framework for RSS and Atom feeds"
HOMEPAGE="https://rometools.github.io/rome/"
SRC_URI="mirror://gentoo/${P}-src.zip -> ${P}.zip"
LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

CDEPEND="dev-java/jdom:0"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.6
	test? ( dev-java/ant-junit:0 )"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.6"

EANT_GENTOO_CLASSPATH="jdom"

JAVA_ANT_REWRITE_CLASSPATH="true"
JAVA_ANT_ENCODING="ISO-8859-1"

java_prepare() {
	# Patch build.xml so the tests pass
	epatch "${FILESDIR}/${P}-build.xml-test-upstream.patch"

	# Keep Ant happy.
	mkdir -p target/lib || die
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar target/${P}.jar
	use doc && java-pkg_dojavadoc dist/docs/api
	use source && java-pkg_dosrc src/java/*
}
