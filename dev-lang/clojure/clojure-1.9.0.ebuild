# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

JAVA_PKG_IUSE="source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="General-purpose programming language with an emphasis on functional programming"
HOMEPAGE="https://clojure.org/"
SRC_URI="https://github.com/clojure/clojure/tarball/${P} -> ${P}.tar.gz"

LICENSE="EPL-1.0 Apache-2.0 BSD"
SLOT="1.9"
KEYWORDS="~amd64 ~x86 ~x86-linux"
RESTRICT="test" # patches welcome to fix the test

RDEPEND="
	>=virtual/jre-1.8"

DEPEND="
	>=virtual/jdk-1.8
	dev-java/ant-core
	dev-java/maven-bin:3.5"

S="${WORKDIR}/clojure-clojure-e5a8cfa"

DOCS=( changes.md CONTRIBUTING.md readme.txt )

src_compile() {
	./antsetup.sh || die "antsetup.sh failed"
	eant local
}

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar "${PN}.jar"
	java-pkg_dolauncher  ${PN}-${SLOT} --main clojure.main
	if use source; then
		mv target/${P}-sources.jar ${PN}-sources.jar
		insinto /usr/share/${PN}-${SLOT}/sources
		doins ${PN}-sources.jar
	fi
	einstalldocs
}
