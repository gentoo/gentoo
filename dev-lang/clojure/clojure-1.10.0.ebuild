# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="General-purpose programming language with an emphasis on functional programming"
HOMEPAGE="https://clojure.org/"
SRC_URI="https://github.com/clojure/clojure/tarball/${P} -> ${P}.tar.gz"

LICENSE="EPL-1.0 Apache-2.0 BSD"
SLOT="1.10"
KEYWORDS="~amd64 ~x86 ~x86-linux"
RESTRICT="test" # patches welcome to fix the test

CDEPEND="
	dev-java/ant-core:0
	dev-java/maven-bin:3.6"

RDEPEND="
	${CDEPEND}
	>=virtual/jre-1.8"

DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.8"

S="${WORKDIR}/clojure-clojure-76b87a6"

DOCS=( changes.md CONTRIBUTING.md readme.txt )

src_compile() {
	./antsetup.sh || die "antsetup.sh failed"
	eant -f build.xml jar
}

src_test() {
	eant -f build.xml test
}

src_install() {
	java-pkg_newjar "${PN}.jar"
	java-pkg_dolauncher  ${PN}-${SLOT} --main clojure.main
	einstalldocs
}
