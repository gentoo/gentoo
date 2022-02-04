# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_REPO_NAME="libretro/dosbox-libretro"
LIBRETRO_COMMIT_SHA="169d476437ec813b462a47254f24cf78473389c8"
KEYWORDS="~amd64 ~x86"
inherit flag-o-matic libretro-core

DESCRIPTION="DOSBox libretro port"
LICENSE="GPL-2+"
SLOT="0"

src_compile() {
	append-cxxflags -std=gnu++11
	default
}
