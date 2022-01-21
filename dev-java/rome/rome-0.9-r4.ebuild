# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

JAVA_PKG_IUSE="doc source test"
JAVA_TESTING_FRAMEWORKS="junit"

inherit java-pkg-2 java-pkg-simple

DESCRIPTION="Java framework for RSS and Atom feeds"
HOMEPAGE="https://rometools.github.io/rome/"
SRC_URI="mirror://gentoo/${P}.zip"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

CP_DEPEND="dev-java/jdom:0"

DEPEND="
	${CP_DEPEND}
	>=virtual/jdk-1.8:*
	test? ( dev-java/ant-junit:0 )"

RDEPEND="
	${CP_DEPEND}
	>=virtual/jre-1.8:*"

BDEPEND="app-arch/unzip"

JAVA_ENCODING="ISO-8859-1"
JAVA_SRC_DIR="src/java"
JAVA_RESOURCE_DIRS="res/java"
JAVA_TEST_SRC_DIRS="src/test"
JAVA_TEST_GENTOO_CLASSPATH="junit"

S="${WORKDIR}/${P}"

src_prepare() {
	default
	mkdir -p res/java/com/sun/syndication || die
	cp {src,res}/java/com/sun/syndication/rome.properties || die

	sed -e 's:\(public \)\(Module\):\1com.sun.syndication.feed.module.\2:' \
		-e 's:\(,\)\(Module\):\1com.sun.syndication.feed.module.\2:' \
		-i src/java/com/sun/syndication/feed/synd/Synd{Feed,Entry}Impl.java || die
}

src_install() {
	default # https://bugs.gentoo.org/789582
	java-pkg-simple_src_install
}
