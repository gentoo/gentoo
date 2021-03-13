# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit xorg-3

DESCRIPTION="AMD Geode GX2 and LX video driver"

KEYWORDS="x86"
IUSE="ztv"

RDEPEND=""
DEPEND="${RDEPEND}
	ztv? (
		sys-kernel/linux-headers
	)"

PATCHES=(
	"${FILESDIR}"/${P}-fix-multiple-definition-of-linker-error.patch
)

pkg_setup() {
	XORG_CONFIGURE_OPTIONS=(
		$(use_enable ztv)
	)
}
