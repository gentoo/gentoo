# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit java-pkg-2

MY_PN="${PN%-bin}"
MY_P="${MY_PN}-v${PV}"

DESCRIPTION="JavaScript optimizing compiler"
HOMEPAGE="https://developers.google.com/closure/compiler/
	https://github.com/google/closure-compiler/"

MAVEN_REPO="https://repo1.maven.org/maven2"
SRC_URI="
	${MAVEN_REPO}/com/google/javascript/${MY_PN}/v${PV}/${MY_P}.jar
		-> ${P}.maven.jar
"
S="${WORKDIR}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	>=virtual/jre-1.8:*
"

src_unpack() {
	:
}

src_compile() {
	:
}

src_install() {
	local jar_dir="/opt/${PN}-${SLOT}/lib"

	java-pkg_jarinto "${jar_dir}"
	java-pkg_newjar "${DISTDIR}/${P}.maven.jar" "${PN}.jar"

	local -a dolauncher_opts=(
		"${MY_PN}"
		--jar "${jar_dir}/${PN}.jar"
		-into /opt
	)
	java-pkg_dolauncher "${dolauncher_opts[@]}"
}
