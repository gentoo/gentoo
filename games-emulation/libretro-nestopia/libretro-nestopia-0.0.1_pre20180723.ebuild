# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/nestopia"
LIBRETRO_COMMIT_SHA="9c335527c5dfa11dfa29bc22ee4ba6efa23c8890"
KEYWORDS="~amd64 ~x86"
inherit libretro-core
S="${WORKDIR}/nestopia-${LIBRETRO_COMMIT_SHA}/libretro"
LIBRETRO_CORE_LIB_FILE="${S}/${LIBRETRO_CORE_NAME}_libretro.so"

DESCRIPTION="Nestopia libretro port"
LICENSE="GPL-2+"
SLOT="0"
