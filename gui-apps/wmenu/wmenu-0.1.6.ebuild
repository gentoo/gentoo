# Copyright 2023-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="dynamic menu for wlroots compositors, maintains the look and feel of dmenu"
HOMEPAGE="https://sr.ht/~adnano/wmenu/"
SRC_URI="https://git.sr.ht/~adnano/wmenu/archive/${PV}.tar.gz -> ${P}.tar.gz"
LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

BDEPEND="
	app-text/scdoc
	dev-util/wayland-scanner
"
RDEPEND="
	x11-libs/cairo
	x11-libs/pango
	dev-libs/wayland
	x11-libs/libxkbcommon
"
DEPEND="
	${RDEPEND}
	dev-libs/wayland-protocols
"
