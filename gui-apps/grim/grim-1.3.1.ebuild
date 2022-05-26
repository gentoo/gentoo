# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Grab images from a Wayland compositor"
HOMEPAGE="https://github.com/emersion/grim"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/emersion/${PN}.git"
else
	SRC_URI="https://github.com/emersion/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm64"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+man jpeg"

DEPEND="
	>=dev-libs/wayland-protocols-1.14
	dev-libs/wayland
	jpeg? ( virtual/jpeg )
	x11-libs/cairo"

RDEPEND="${DEPEND}"

if [[ ${PV} == 9999 ]]; then
	BDEPEND+="man? ( ~app-text/scdoc-9999 )"
else
	BDEPEND+="man? ( app-text/scdoc )"
fi

src_configure() {
	local emesonargs=(
		$(meson_feature jpeg)
		$(meson_feature man man-pages)
	)
	meson_src_configure
}
