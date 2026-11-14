# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=9

DESCRIPTION="The 'Activate Windows' watermark ported to Linux"
HOMEPAGE="https://github.com/MrGlockenspiel/activate-linux"

if [[ "${PV}" = 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="${HOMEPAGE}.git"
else
	SRC_URI="https://github.com/MrGlockenspiel/${PN}/archive/refs/tags/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
fi

LICENSE="GPL-3"
SLOT="0"

BDEPEND="
	dev-libs/wayland-protocols
	dev-util/wayland-scanner
"

RDEPEND="
	dev-libs/wayland
	x11-libs/cairo[X]
	x11-libs/libXfixes
	x11-libs/libXinerama
	x11-libs/libXrandr
	x11-libs/pango
"

src_install() {
	dobin activate-linux
	einstalldocs
}
