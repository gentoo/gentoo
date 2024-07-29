# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit mate

MINOR=$(($(ver_cut 2) % 2))
if [[ ${MINOR} -eq 0 ]]; then
	KEYWORDS="amd64 ~arm ~arm64 ~loong ~riscv x86"
fi

DESCRIPTION="Multimedia related programs for the MATE desktop"
LICENSE="FDL-1.1+ GPL-2+ HPND LGPL-2+"
SLOT="0"

COMMON_DEPEND="
	>=dev-libs/glib-2.50:2
	dev-libs/libxml2:2
	>=mate-base/mate-panel-1.28.0
	>=mate-base/mate-desktop-1.28.0
	>=media-libs/libcanberra-0.13[gtk3]
	>=media-libs/libmatemixer-1.28.0
	x11-libs/cairo
	>=x11-libs/gtk+-3.22:3
	x11-libs/pango
"

BDEPEND="${COMMON_DEPEND}
	virtual/libintl
"

DEPEND="${COMMON_DEPEND}
	>=sys-devel/gettext-0.19.8
	virtual/pkgconfig
"
