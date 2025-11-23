# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake

DESCRIPTION="Linux port of the classical Atari ST game Ballerburg"
HOMEPAGE="https://baller.tuxfamily.org/"
SRC_URI="https://download.tuxfamily.org/baller/${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="media-libs/libsdl"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${P}-nomancompress.patch" )

src_configure() {
	local mycmakeargs=(
		-DDOCDIR=share/doc/${PF}
	)
	cmake_src_configure
}
