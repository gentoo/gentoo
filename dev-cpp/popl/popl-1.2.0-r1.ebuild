# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Header-only C++ program options parser library"
HOMEPAGE="https://github.com/badaix/popl"
SRC_URI="https://github.com/badaix/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm ppc ppc64 ~riscv x86"

src_configure() {
	local mycmakeargs=( -DBUILD_EXAMPLE=OFF )

	cmake_src_configure
}
