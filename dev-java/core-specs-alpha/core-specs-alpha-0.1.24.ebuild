# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-ant-2

EGIT_REF="43815fc"

MY_PN=${PN//-/.}
MY_P=${MY_PN}-${PV}

DESCRIPTION="A Clojure library with specs to describe Clojure core macros and functions."
HOMEPAGE="https://clojure.org/ https://github.com/clojure/core.specs.alpha"
SRC_URI="https://github.com/clojure/${MY_PN}/archive/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="0.1"
KEYWORDS="~amd64 ~x86 ~x86-linux"
IUSE=""

CDEPEND="dev-java/ant-core:0"
RDEPEND=">=virtual/jre-1.8:*"
DEPEND="
	${CDEPEND}
	>=virtual/jdk-1.8:*"

S="${WORKDIR}/${MY_PN}-${MY_P}"

EANT_TASKS="jar"
EANT_EXTRA_ARGS="-Dmaven.build.finalName=${MY_P}"

src_prepare() {
	default
	cp "${FILESDIR}/build.xml" . || die
}

src_install() {
	java-pkg_newjar "target/${MY_P}.jar"
	dodoc CONTRIBUTING.md README.md
}
