# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="A/52 (AC-3) audio encoder"
HOMEPAGE="https://aften.sourceforge.net/"
SRC_URI="https://downloads.sourceforge.net/${PN}/${P}.tar.bz2"

LICENSE="LGPL-2.1 BSD"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"
IUSE="cxx"

DOCS=( README Changelog )

PATCHES=(
	"${FILESDIR}/${P}-multilib.patch"
	"${FILESDIR}/${P}-ppc.patch"
	"${FILESDIR}/${P}-no-static-aften.patch"
	"${FILESDIR}/${P}-arm64.patch" # thx to macports
	"${FILESDIR}/${P}-cmake4.patch" # downstream patch
)

src_configure() {
	local mycmakeargs=(
		-DSHARED=1
		-DBINDINGS_CXX=$(usex cxx) # "only lightly tested"
	)
	cmake_src_configure
}

src_install() {
	cmake_src_install
	# File collision with media-sound/wavbreaker, upstream informed
	mv "${ED}"/usr/bin/wavinfo{,-aften} || die
}
