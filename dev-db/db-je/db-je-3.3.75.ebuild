# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=0

JAVA_PKG_IUSE="doc source"

inherit java-pkg-2 java-ant-2

DESCRIPTION="A high performance, transactional storage engine written entirely in Java"
HOMEPAGE="https://www.oracle.com/database/berkeley-db/java-edition.html"
SRC_URI="http://download.oracle.com/berkeley-db/${P/db-/}.tar.gz"

LICENSE="Sleepycat BSD"
SLOT="3.3"
KEYWORDS="amd64 x86"
IUSE=""

DEPEND=">=virtual/jdk-1.5"
RDEPEND=">=virtual/jre-1.5"
S=${WORKDIR}/${P/db-/}

src_unpack() {
	unpack ${A}
	cd "${S}" || die
	epatch "${FILESDIR}"/${P}-optional-test.patch
	rm -rf docs
	cd lib || die
	rm -v *jar || die
	java-pkg_jar-from --build-only ant-core ant.jar
}

EANT_DOC_TARGET="javadoc-all"
EANT_EXTRA_ARGS="-Dnotest=true"

src_install() {
	java-pkg_dojar build/lib/je.jar
	use doc && java-pkg_dojavadoc docs
	use source && java-pkg_dosrc src/com
}
