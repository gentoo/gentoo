# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

COMMIT="8bd6bad750b2b0d90800c632cf18e8ee93ad72d7"

DESCRIPTION="Helper routines and frameworks used by KarypisLab software"
HOMEPAGE="https://github.com/KarypisLab/GKlib"
SRC_URI="https://github.com/KarypisLab/GKlib/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
S="${WORKDIR}/GKlib-${COMMIT}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ~loong ~ppc ~ppc64 ~riscv ~x86 ~arm64-macos ~x64-macos"

PATCHES=(
	"${FILESDIR}/${P}-multilib.patch"
	"${FILESDIR}/${P}-respect-user-flags.patch"
)

src_configure() {
	local mycmakeargs=()
	if ! use amd64 && ! use x86; then # bug 905642
		mycmakeargs+=(
			-DNO_X86=ON
		)
	fi
	cmake_src_configure
}
