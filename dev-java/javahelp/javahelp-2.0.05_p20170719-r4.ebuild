# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc examples source"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="The JavaHelp system online help system"
HOMEPAGE="https://javaee.github.io/javahelp/"
COMMIT="3ca862d8626096770598a3a256886d205246f4a4"
SRC_URI="https://github.com/javaee/${PN}/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/${PN}-${COMMIT}"

LICENSE="GPL-2-with-linking-exception"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CP_DEPEND="
	dev-java/javax-jsp-api:2.0
	dev-java/javax-servlet-api:2.5
"

DEPEND="${CP_DEPEND}
	virtual/jdk:1.8"

RDEPEND="${CP_DEPEND}
	>=virtual/jre-1.8:*"

JAVA_JAR_FILENAME="jhall.jar"
JAVA_GENTOO_CLASSPATH_EXTRA="javahelp_nbproject/lib/jdic-stub.jar"
JAVA_RESOURCE_DIRS="res"
JAVA_SRC_DIR=(
	jhMaster/JavaHelp/src/{new,impl}
	jhMaster/JSearch/{client,indexer}
)

src_prepare() {
	java-pkg-2_src_prepare
	mkdir res || die
	pushd jhMaster/JavaHelp/src/new >> /dev/null || die
		find -type f ! -name '*.java' | xargs cp --parents -t ../../../../res || die
	popd >> /dev/null || die
}

src_install() {
	java-pkg-simple_src_install

	java-pkg_dolauncher jhsearch \
		--main com.sun.java.help.search.QueryEngine
	java-pkg_dolauncher jhindexer \
		--main com.sun.java.help.search.Indexer

	use examples && java-pkg_doexamples jhMaster/JavaHelp/demos
}
