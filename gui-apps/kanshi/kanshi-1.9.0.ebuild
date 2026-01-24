# Copyright 2020-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="dynamic display configuration (autorandr for wayland)"
HOMEPAGE="https://gitlab.freedesktop.org/emersion/kanshi"
SRC_URI="https://gitlab.freedesktop.org/emersion/kanshi/-/archive/v${PV}/kanshi-v${PV}.tar.bz2"
S=${WORKDIR}/${PN}-v${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+man varlink"

RDEPEND="
	dev-libs/json-c:=
	dev-libs/libscfg:=
	dev-libs/wayland
	varlink? ( dev-libs/vali )
"
DEPEND="${RDEPEND}"
BDEPEND="
	virtual/pkgconfig
	dev-libs/wayland-protocols
	dev-util/wayland-scanner
	man? ( >=app-text/scdoc-1.9.3 )
	varlink? ( dev-libs/vali )
"

src_configure() {
	local emesonargs=(
		$(meson_feature man man-pages)
		$(meson_feature varlink ipc)
	)
	meson_src_configure
}
