# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Free stand-alone ini file parsing library"
HOMEPAGE="https://gitlab.com/iniparser/iniparser/"
SRC_URI="https://gitlab.com/iniparser/iniparser/-/archive/v${PV}/${PN}-v${PV}.tar.bz2"
S=${WORKDIR}/${PN}-v${PV}

LICENSE="MIT"
SLOT="0/4"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ppc ppc64 ~riscv ~s390 ~sparc x86 ~x64-macos ~x64-solaris"
IUSE="doc examples"
# tests need work, uses ruby + fetchcontent
RESTRICT="test"

BDEPEND="doc? ( app-text/doxygen )"

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCS=$(usex doc)
		-DBUILD_STATIC_LIBS=no
	)

	cmake_src_configure
}

src_install() {
	local DOCS=( AUTHORS README.md FAQ* )
	cmake_src_install

	if use examples; then
		docinto examples
		dodoc -r example/.
	fi
}
