# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

JAVA_PKG_IUSE="test"

inherit java-pkg-2 java-ant-2

DESCRIPTION="General-purpose programming language with an emphasis on functional programming"
HOMEPAGE="https://clojure.org/"
SRC_URI="https://github.com/${PN}/${PN}/archive/${P}.tar.gz"

LICENSE="EPL-1.0 Apache-2.0 BSD"
SLOT="$(ver_cut 1-2)"

KEYWORDS="~amd64 ~x86 ~x86-linux"

# Restrict test as broken due to file not found issue and more.
RESTRICT="!test? ( test )"

COMMON_DEPEND="
	dev-java/spec-alpha:0.2
	dev-java/core-specs-alpha:0.2
	dev-java/ant-core:0"

RDEPEND="${COMMON_DEPEND}
	>=virtual/jre-1.8"

DEPEND="${COMMON_DEPEND}
	>=virtual/jdk-1.8"

S="${WORKDIR}/${PN}-${P}"

DOCS=( changes.md CONTRIBUTING.md readme.txt )

src_compile() {
	eant -Dmaven.compile.classpath=$(java-pkg_getjars core-specs-alpha-0.2,spec-alpha-0.2) -f build.xml jar
}

src_test() {
	eant -f build.xml test
}

src_install() {
	java-pkg_newjar "${PN}.jar"
	java-pkg_dolauncher ${PN}-${SLOT} --main clojure.main
	einstalldocs
}
