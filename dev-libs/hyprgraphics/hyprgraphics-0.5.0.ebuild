# Copyright 2023-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Hyprland graphics / resource utilities"
HOMEPAGE="https://github.com/hyprwm/hyprgraphics"
SRC_URI="https://github.com/hyprwm/${PN}/archive/v${PV}.tar.gz -> ${P}.gh.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	>=gui-libs/hyprutils-0.1.1:=
	media-libs/libjpeg-turbo:=
	media-libs/libjxl:=
	media-libs/libspng
	media-libs/libwebp:=
	sys-apps/file
	x11-libs/cairo
"
DEPEND="${RDEPEND}"
