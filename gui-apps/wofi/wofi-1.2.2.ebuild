# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson
if [ "${PV}" = 9999 ]
then
	inherit mercurial
	EHG_REPO_URI="https://hg.sr.ht/~scoopta/wofi"
else
	SRC_URI="https://hg.sr.ht/~scoopta/wofi/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${PN}-v${PV}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Wofi is a launcher/menu program for wlroots based wayland compositors like sway"
HOMEPAGE="https://hg.sr.ht/~scoopta/wofi"
LICENSE="GPL-3"

IUSE="+run +drun +dmenu"

DEPEND="
	dev-libs/wayland
	x11-libs/gtk+:3[wayland]"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

RESTRICT="test"

SLOT="0"

src_configure() {
	local emesonargs=(
		$(meson_use run enable_run)
		$(meson_use drun enable_drun)
		$(meson_use dmenu enable_dmenu)
	)
	meson_src_configure
}
