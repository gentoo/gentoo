# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake

DESCRIPTION="A free stand-alone ini file parsing library"
HOMEPAGE="https://gitlab.com/iniparser/iniparser"
SRC_URI="https://gitlab.com/iniparser/iniparser/-/archive/v${PV}/iniparser-v${PV}.tar.bz2 -> ${P}.tar.bz2"

S="${WORKDIR}/${PN}-v${PV}"
LICENSE="MIT"
SLOT="4"
#KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x64-solaris"
IUSE="doc examples"

BDEPEND="doc? ( app-text/doxygen )"

src_configure() {
	local mycmakeargs=(
		-DBUILD_DOCS=$(usex doc)
		-DBUILD_EXAMPLES=$(usex examples)
	)

	cmake_src_configure
}
