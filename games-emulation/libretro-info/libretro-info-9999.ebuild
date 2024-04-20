# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Libretro info files required for libretro cores"
HOMEPAGE="https://github.com/libretro/libretro-super"

if [[ ${PV} == *9999 ]]; then
	SRC_URI=""
	EGIT_REPO_URI="https://github.com/libretro/libretro-super.git"
	inherit git-r3
else
	COMMIT="dfa0eaaa804552712baaff5553df3eea989fc5d5"
	SRC_URI="https://github.com/libretro/libretro-super/archive/${COMMIT}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/libretro-super-${COMMIT}"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="GPL-3"
SLOT="0"

src_compile() {
	:
}

src_install() {
	insinto "/usr/share/libretro/info"
	doins dist/info/*.info
}
