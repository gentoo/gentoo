# Copyright 2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake xdg-utils

MY_PN="${PN^}"
S="${WORKDIR}/${P^}"

DESCRIPTION="A C daemon that turns your webcam into a light sensor"
HOMEPAGE="https://github.com/FedeDP/Clight"
SRC_URI="https://github.com/FedeDP/${MY_PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="bash-completion geoclue upower"

PATCHES=( "${FILESDIR}/clight-4.0-icon-extension.patch" )

DEPEND="
	|| ( sys-auth/elogind sys-apps/systemd )
	dev-libs/popt
	sci-libs/gsl
	dev-libs/libconfig
"

RDEPEND="
	${DEPEND}
	app-misc/clightd
	geoclue? ( app-misc/geoclue )
	upower? ( sys-power/upower )
"

BDEPEND="
	${DEPEND}
	dev-libs/libmodule
	dev-util/cmake
	virtual/pkgconfig
	sys-apps/dbus
	bash-completion? ( app-shells/bash-completion )
"

pkg_postinst() {
	xdg_icon_cache_update
}

pkg_postrm() {
	xdg_icon_cache_update
}
