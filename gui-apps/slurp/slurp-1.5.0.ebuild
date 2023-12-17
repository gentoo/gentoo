# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="Select a region in a Wayland compositor and print it to the standard output"
HOMEPAGE="https://github.com/emersion/slurp"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/emersion/${PN}.git"
else
	SRC_URI="https://github.com/emersion/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~arm64 ~loong ~ppc64 ~riscv ~x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="+man"

DEPEND="
	>=dev-libs/wayland-protocols-1.14
	dev-libs/wayland
	x11-libs/cairo
	x11-libs/libxkbcommon
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/wayland-scanner
	man? ( app-text/scdoc )
"

src_configure() {
	local emesonargs=(
		$(meson_feature man man-pages)
	)
	meson_src_configure
}
