# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CMAKE_MAKEFILE_GENERATOR="emake"
inherit cmake

DESCRIPTION="Linux port of the classical Atari ST game Ballerburg"
HOMEPAGE="https://baller.tuxfamily.org/"
SRC_URI="https://framagit.org/baller/ballerburg/-/archive/v${PV}/ballerburg-v${PV}.tar.bz2"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="media-libs/libsdl"
RDEPEND="${DEPEND}"

PATCHES=( "${FILESDIR}/${PN}-1.2.0-nomancompress.patch" )

S=${WORKDIR}/${PN}-v${PV}

src_configure() {
	local mycmakeargs=(
		-DDOCDIR=share/doc/${PF}
	)
	cmake_src_configure
}
