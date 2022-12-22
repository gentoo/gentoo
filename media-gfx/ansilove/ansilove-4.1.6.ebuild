# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="ANSI and ASCII art to PNG converter (using libansilove)"
HOMEPAGE="https://github.com/ansilove/ansilove/"

if [[ "${PV}" == *9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/ansilove/${PN}.git"
else
	SRC_URI="https://github.com/ansilove/${PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm ~arm64 ~riscv ~x86"
fi

LICENSE="BSD-2"
SLOT="0"

RDEPEND="dev-libs/libansilove"
DEPEND="${RDEPEND}"

src_configure() {
	local mycmakeargs=(
		-DENABLE_SECCOMP=NO
	)
	cmake_src_configure
}
