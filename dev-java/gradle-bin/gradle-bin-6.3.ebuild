# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

IUSE="doc"
JAVA_PKG_IUSE="source"

inherit java-pkg-2

MY_PN=${PN%%-bin}
MY_P="${MY_PN}-${PV/_rc/-rc-}"

DESCRIPTION="A project automation and build tool with a Groovy based DSL"
SRC_URI="https://services.gradle.org/distributions/${MY_P}-all.zip -> ${P}.zip"
HOMEPAGE="https://www.gradle.org/"

LICENSE="Apache-2.0"
SLOT="${PV}"
KEYWORDS="~amd64 ~x86"

BDEPEND="app-arch/unzip"
DEPEND=">=virtual/jre-1.8"
RDEPEND=">=virtual/jdk-1.8"

S="${WORKDIR}/${MY_P}"

src_install() {
	local gradle_dir="${EPREFIX}/usr/share/${PN}-${SLOT}"

	insinto "${gradle_dir}"
	doins -r lib/

	exeinto "${gradle_dir}"/bin
	doexe bin/${MY_PN}
	dosym "../${gradle_dir##*/usr/}/bin/gradle" "/usr/bin/${MY_PN}-${SLOT}"

	docinto html
	dodoc -r docs/release-notes.html

	if use doc ; then
		dodoc -r docs/{dsl,userguide}
		java-pkg_dojavadoc docs/javadoc
	fi

	if use source ; then
		java-pkg_dosrc src/*
	fi
}
