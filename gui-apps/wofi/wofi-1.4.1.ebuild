# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

if [[ "${PV}" == 9999 ]]; then
	inherit mercurial
	EHG_REPO_URI="https://hg.sr.ht/~scoopta/${PN}"
else
	SRC_URI="https://hg.sr.ht/~scoopta/wofi/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-v${PV}"
	KEYWORDS="amd64 ~riscv"
fi

DESCRIPTION="Wofi is a launcher/menu program for wlroots based wayland compositors like sway"
HOMEPAGE="https://hg.sr.ht/~scoopta/wofi"

LICENSE="GPL-3"
SLOT="0"

DEPEND="
	dev-libs/glib:2
	dev-libs/wayland
	x11-libs/cairo
	x11-libs/gdk-pixbuf:2
	x11-libs/gtk+:3[wayland(-)]
	x11-libs/pango
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

PATCHES=( "${FILESDIR}/${PN}-1.3-no-hg-identify.patch" )
