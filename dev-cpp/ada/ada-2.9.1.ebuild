# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="WHATWG-compliant and fast URL parser written in modern C++"
HOMEPAGE="https://github.com/ada-url/ada"

SRC_URI="https://github.com/ada-url/ada/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0 MIT"
SLOT="0/$(ver_cut 1)"
KEYWORDS="amd64 ~arm64 ~loong ~riscv"
RESTRICT="test"

src_configure() {
	local mycmakeargs=(
		# Building anything other than the library requires the CPM package manager
		# which isn't very well equipped for packaging...
		-DADA_TESTING=NO
		-DADA_TOOLS=NO
	)
	cmake_src_configure
}
