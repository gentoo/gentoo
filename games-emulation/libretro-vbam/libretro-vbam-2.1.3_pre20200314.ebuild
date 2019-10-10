# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/vbam-libretro"
LIBRETRO_COMMIT_SHA="29dffc0120681853855c2ce57911f9e2d33607dc"

inherit libretro-core

DESCRIPTION="A fork of VBA-M with libretro integration"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"

S="${S}/src/libretro"
