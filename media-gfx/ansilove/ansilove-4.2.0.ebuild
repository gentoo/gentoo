# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="ANSI and ASCII art to PNG converter (using libansilove)"
HOMEPAGE="https://www.ansilove.org/
	https://github.com/ansilove/ansilove/"

if [[ ${PV} == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/${PN}/${PN}.git"
else
	SRC_URI="https://github.com/${PN}/${PN}/archive/${PV}.tar.gz
		-> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="BSD-2"
SLOT="0"

RDEPEND=">=dev-libs/libansilove-1.4.0:="
DEPEND="${RDEPEND}"

src_configure() {
	local -a mycmakeargs=(
		-DENABLE_SECCOMP=NO
	)
	cmake_src_configure
}
