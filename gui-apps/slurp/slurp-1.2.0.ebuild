# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="Select a region in a Wayland compositor and print it to the standard output."
HOMEPAGE="https://github.com/emersion/slurp"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/emersion/${PN}.git"
else
	SRC_URI="https://github.com/emersion/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="amd64 ~arm64"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+man"

DEPEND="
	>=dev-libs/wayland-protocols-1.14
	dev-libs/wayland
	x11-libs/cairo"

RDEPEND="${DEPEND}"

if [[ ${PV} == 9999 ]]; then
	BDEPEND+="man? ( ~app-text/scdoc-9999 )"
else
	BDEPEND+="man? ( app-text/scdoc )"
fi

src_configure() {
	local emesonargs=(
		$(meson_feature man man-pages)
		"-Dwerror=false"
	)
	meson_src_configure
}
