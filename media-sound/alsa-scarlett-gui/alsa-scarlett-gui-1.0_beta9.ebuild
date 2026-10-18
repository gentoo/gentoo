# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs xdg

DESCRIPTION="A UI for Focusrite Scarlett and Clarett audio interfaces"
HOMEPAGE="https://github.com/geoffreybennett/alsa-scarlett-gui"
MY_PV="${PV//_/}"
SRC_URI="https://github.com/geoffreybennett/${PN}/archive/${MY_PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	dev-libs/glib:2
	gui-libs/gtk:4
	media-libs/alsa-lib
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

MAKEOPTS="${MAKEOPTS} -C src"

S="${WORKDIR}/${PN}-${MY_PV}"
export PREFIX="/usr"

src_compile() {
	emake CC="$(tc-getCC)"
}
