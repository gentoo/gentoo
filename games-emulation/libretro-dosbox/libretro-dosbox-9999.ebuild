# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/dosbox-libretro"
inherit libretro-core flag-o-matic

DESCRIPTION="DOSBox libretro port"
LICENSE="GPL-2+"
SLOT="0"

src_compile() {
	append-cxxflags -std=gnu++11
	default
}
