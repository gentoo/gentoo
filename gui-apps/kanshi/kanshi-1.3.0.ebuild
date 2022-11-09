# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit meson

DESCRIPTION="dynamic display configuration (autorandr for wayland)"
HOMEPAGE="https://wayland.emersion.fr/kanshi/ https://sr.ht/~emersion/kanshi/"
SRC_URI="
	https://git.sr.ht/~emersion/kanshi/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"
S=${WORKDIR}/${PN}-v${PV}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE="+man varlink"

RDEPEND="
	dev-libs/wayland
	varlink? ( dev-libs/libvarlink )
"
BDEPEND="
	${RDEPEND}
	virtual/pkgconfig
	dev-libs/wayland-protocols
	man? ( >=app-text/scdoc-1.9.3 )
"

src_configure() {
	local emesonargs=(
		$(meson_feature man man-pages)
		$(meson_feature varlink ipc)
	)
	meson_src_configure
}
