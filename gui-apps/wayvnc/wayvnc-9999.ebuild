# Copyright 2019-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit meson

DESCRIPTION="VNC server for wlroots based Wayland compositors"
HOMEPAGE="https://github.com/any1/wayvnc"

if [[ ${PV} == 9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/any1/wayvnc.git"
else
	SRC_URI="https://github.com/any1/wayvnc/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~riscv ~x86"
fi

LICENSE="ISC"
SLOT="0"
IUSE="gbm tracing"

RDEPEND="
	=dev-libs/aml-0.3*
	dev-libs/wayland
	=gui-libs/neatvnc-0.6*[tracing?]
	media-libs/mesa:=[egl(+),gles2,gbm(+)?]
	x11-libs/libxkbcommon
	x11-libs/pixman
	tracing? ( dev-util/systemtap )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	dev-libs/wayland-protocols
"

src_configure() {
	local emesonargs=(
		$(meson_feature gbm screencopy-dmabuf)
		$(meson_use tracing systemtap)
	)
	meson_src_configure
}
