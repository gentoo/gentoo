# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A high performance, transactional storage engine written entirely in Java"
HOMEPAGE="https://www.oracle.com/database/berkeley-db/java-edition.html"
SRC_URI="https://download.oracle.com/berkeley-db/${P/db-/}.tar.gz"

LICENSE="Sleepycat BSD"
SLOT="3.3"
KEYWORDS="~amd64 ~x86"

DEPEND="virtual/jdk:1.8
	dev-java/ant-core:0"
RDEPEND="virtual/jre:1.8"

S=${WORKDIR}/${P/db-/}

EANT_DOC_TARGET="javadoc-all"
EANT_EXTRA_ARGS="-Dnotest=true"
JAVA_ANT_REWRITE_CLASSPATH="true"

PATCHES=(
	"${FILESDIR}"/${P}-optional-test.patch
	# allow using source="1.8" target="1.8"
	"${FILESDIR}"/db-je-3.3.75-compile.xml.patch
)

src_prepare() {
	default
	rm -r docs || die
	cd lib || die
	rm -v *.jar || die
	java-pkg_jar-from --build-only ant-core ant.jar
}

src_install() {
	java-pkg_dojar build/lib/je.jar
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc src/com
}
