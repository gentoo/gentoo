# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-ant-2

EGIT_REF="053d789"

MY_PN=core.specs.alpha
MY_P=${MY_PN}-${PV}

DESCRIPTION="A Clojure library with specs to describe Clojure core macros and functions"
HOMEPAGE="https://clojure.org/ https://github.com/clojure/core.specs.alpha"
SRC_URI="https://github.com/clojure/core.specs.alpha/archive/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="0.2"
KEYWORDS="~amd64 ~x86 ~x86-linux"

RDEPEND=">=virtual/jre-1.8:*"

DEPEND="
	dev-java/ant-core:0
	>=virtual/jdk-1.8:*
"

S="${WORKDIR}/${MY_PN}-${MY_P}"

DOCS=( CONTRIBUTING.md LICENSE README.md )

EANT_TASKS="jar"
EANT_EXTRA_ARGS="-Dmaven.build.finalName=${MY_P}"

src_prepare() {
	default
	rm -r CHANGES.md epl-v10.html || die # epl-10.html is the LICENSE in html format
	cp "${FILESDIR}/build.xml" . || die
}

src_install() {
	java-pkg_newjar "target/${MY_P}.jar"
	einstalldocs
}
