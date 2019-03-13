# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/nestopia"
inherit libretro-core
S="${WORKDIR}/${P}/libretro"
LIBRETRO_CORE_LIB_FILE="${S}/${LIBRETRO_CORE_NAME}_libretro.so"

DESCRIPTION="Nestopia libretro port"
LICENSE="GPL-2+"
SLOT="0"
