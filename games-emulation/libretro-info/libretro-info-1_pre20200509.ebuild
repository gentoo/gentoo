# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

LIBRETRO_COMMIT_SHA="64f9be98c6cb6d440bd474c59d4f1638b4f3c1f9"

inherit vcs-snapshot

DESCRIPTION="Libretro info files required for libretro cores"
HOMEPAGE="https://github.com/libretro/libretro-super"
SRC_URI="https://github.com/libretro/libretro-super/archive/${LIBRETRO_COMMIT_SHA}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"

src_compile() {
	:
}

src_install() {
	insinto "/usr/share/libretro/info"
	doins dist/info/*.info
}
