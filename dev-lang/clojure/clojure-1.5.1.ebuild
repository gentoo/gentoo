# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
JAVA_PKG_IUSE="source test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="Clojure is a dynamic programming language that targets the Java Virtual Machine"
HOMEPAGE="https://clojure.org/"
SRC_URI="https://github.com/clojure/clojure/tarball/${P} -> ${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="1.5"
KEYWORDS="amd64 x86 ~x86-linux"
IUSE=""
RESTRICT="test" # patches welcome to fix the test

RDEPEND=">=virtual/jre-1.5"
DEPEND=">=virtual/jdk-1.5"

S=${WORKDIR}/clojure-clojure-22c7e75

src_test() {
	java-pkg-2_src_test
}

src_install() {
	java-pkg_newjar ${P/_/-}.jar
	java-pkg_dolauncher  ${PN}-${SLOT} --main clojure.main
	dodoc changes.md readme.txt
}
