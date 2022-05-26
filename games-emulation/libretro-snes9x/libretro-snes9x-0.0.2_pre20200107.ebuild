# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/snes9x"
LIBRETRO_COMMIT_SHA="6db918cfe32b157239da44096091c212fdfb3b60"
KEYWORDS="~amd64 ~x86"
inherit libretro-core
DEPEND="!>=games-emulation/snes9x-1.60[libretro]"
S="${S}/libretro"
LIBRETRO_CORE_LIB_FILE="${S}/${LIBRETRO_CORE_NAME}_libretro.so"

DESCRIPTION="Snes9x libretro port"
LICENSE="Snes9x GPL-2 GPL-2+ LGPL-2.1 LGPL-2.1+ ISC MIT ZLIB Info-ZIP"
RESTRICT="bindist"
SLOT="0"

src_prepare() {
	cd .. || die
	eapply "${FILESDIR}"/${PN}-0.0.2_pre20200107-gcc11-const.patch
	cd "${S}" || die

	libretro-core_src_prepare
}
