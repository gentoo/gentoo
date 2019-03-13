# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/snes9x"
inherit libretro-core
S="${S}/libretro"
LIBRETRO_CORE_LIB_FILE="${S}/${LIBRETRO_CORE_NAME}_libretro.so"

DESCRIPTION="Snes9x libretro port"
LICENSE="Snes9x GPL-2 GPL-2+ LGPL-2.1 LGPL-2.1+ ISC MIT ZLIB Info-ZIP"
RESTRICT="bindist"
SLOT="0"
