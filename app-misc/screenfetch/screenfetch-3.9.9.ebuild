# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

DESCRIPTION="Bash Screenshot Information Tool"
HOMEPAGE="https://github.com/KittyKatt/screenFetch"
SRC_URI="https://github.com/KittyKatt/screenFetch/archive/v${PV}.tar.gz -> ${P}.tar.gz"
S=${WORKDIR}/${PN/f/F}-${PV}

LICENSE="GPL-3+"
SLOT="0"
KEYWORDS="~amd64 ~arm ~loong ~riscv ~x86 ~x64-macos"

src_install() {
	newbin ${PN}-dev ${PN}
	einstalldocs
}

pkg_postinst() {
	optfeature "screenshot taking" media-gfx/scrot
	optfeature "screenshot uploading" net-misc/curl
	optfeature "resolution detection" x11-apps/xdpyinfo
}
