# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

MY_PN="intel-vaapi-driver"
if [[ ${PV} = *9999* ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/irql-notlessorequal/intel-vaapi-driver"
fi

inherit meson-multilib

DESCRIPTION="HW video decode support for Intel integrated graphics"
HOMEPAGE="https://github.com/irql-notlessorequal/intel-vaapi-driver"
if [[ ${PV} != *9999* ]] ; then
	SRC_URI="https://github.com/irql-notlessorequal/${MY_PN}/archive/refs/tags/${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${MY_PN}-${PV}"
	KEYWORDS="amd64 x86"
fi

LICENSE="MIT"
SLOT="0"
IUSE="hybrid wayland X"
RESTRICT="test" # No tests

RDEPEND="
	>=x11-libs/libdrm-2.4.52[video_cards_intel,${MULTILIB_USEDEP}]
	>=media-libs/libva-2.4.0:=[X?,wayland?,${MULTILIB_USEDEP}]

	hybrid? (
		>=media-libs/intel-hybrid-codec-driver-2.0.0[X?,wayland?]
	)

	wayland? (
		>=dev-libs/wayland-1.11[${MULTILIB_USEDEP}]
		virtual/opengl[${MULTILIB_USEDEP}]
	)
"
DEPEND="${RDEPEND}"
BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
"

multilib_src_configure() {
	local emesonargs=(
		-Denable_hybrid_codec=$(usex hybrid true false)
		-Dwith_wayland=$(usex wayland)
		-Dwith_x11=$(usex X)
	)
	meson_src_configure
}
