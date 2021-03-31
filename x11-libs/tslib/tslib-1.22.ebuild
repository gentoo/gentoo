# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

CMAKE_ECLASS=cmake
inherit cmake-multilib

DESCRIPTION="Touchscreen Access Library"
HOMEPAGE="https://github.com/kergoth/tslib"
SRC_URI="https://github.com/libts/tslib/releases/download/${PV}/${P}.tar.xz"

LICENSE="LGPL-2 uinput? ( GPL-2+ )"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86"
IUSE="evdev sdl uinput"

BDEPEND="
	evdev? ( virtual/pkgconfig )
"
DEPEND="
	evdev? ( dev-libs/libevdev[${MULTILIB_USEDEP}] )
	sdl? ( media-libs/libsdl2[${MULTILIB_USEDEP}] )
"
RDEPEND="${DEPEND}"

DOCS=( AUTHORS NEWS README{,.md} )

PATCHES=( "${FILESDIR}/${PN}-1.21-optional-utils.patch" )

src_configure() {
	my_configure() {
		local mycmakeargs=(
			-Denable-input-evdev=$(usex evdev)
			-DENABLE_TOOLS=$(usex uinput $(multilib_is_native_abi && echo ON || echo OFF) OFF)
			-DENABLE_UTILS=$(multilib_is_native_abi && echo ON || echo OFF)
			-Denable-arctic2=ON
			-Denable-collie=ON
			-Denable-corgi=ON
			-Denable-cy8mrln-palmpre=ON
			-Denable-dejitter=ON
			-Denable-dmc=ON
			-Denable-dmc_dus3000=ON
			-Denable-galax=ON
			-Denable-h3600=ON
			-Denable-input=ON
			-Denable-linear-h2200=ON
			-Denable-linear=ON
			-Denable-mk712=ON
			-Denable-one-wire-ts-input=ON
			-Denable-pthres=ON
			-Denable-tatung=ON
			-Denable-ucb1x00=ON
			-Denable-variance=ON
		)
		multilib_is_native_abi && mycmakeargs+=( -Dwith-sdl=$(usex sdl) )

		cmake_src_configure
	}
	multilib_parallel_foreach_abi my_configure
}
