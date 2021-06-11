# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit java-pkg-2 java-ant-2

EGIT_REF="fb55378"

MY_P=spec.alpha-${PV}

DESCRIPTION="A Clojure library to describe the structure of data and functions"
HOMEPAGE="https://clojure.org/ https://github.com/clojure/spec.alpha"
SRC_URI="https://github.com/clojure/spec.alpha/archive/${MY_P}.tar.gz -> ${P}.tar.gz"

LICENSE="EPL-1.0"
SLOT="0.2"
KEYWORDS="~amd64 ~x86 ~x86-linux"

RDEPEND=">=virtual/jre-1.8:*"
DEPEND="
	dev-java/ant-core:0
	>=virtual/jdk-1.8:*
"

S="${WORKDIR}/spec.alpha-${MY_P}"

EANT_TASKS="jar"
EANT_EXTRA_ARGS="-Dmaven.build.finalName=${MY_P}"

src_prepare() {
	default
	cp "${FILESDIR}/build.xml" . || die
}

src_install() {
	java-pkg_newjar "target/${MY_P}.jar"
	einstalldocs
}
