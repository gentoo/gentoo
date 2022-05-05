# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit optfeature

MY_PN="${PN/f/F}"

DESCRIPTION="Bash Screenshot Information Tool"
HOMEPAGE="https://github.com/KittyKatt/screenFetch"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/KittyKatt/screenFetch.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm ~loong ~x86 ~x64-macos"
	SRC_URI="https://github.com/KittyKatt/screenFetch/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

LICENSE="GPL-3+"
SLOT="0"

src_install() {
	newbin ${PN}-dev ${PN}
	einstalldocs
}

pkg_postinst() {
	optfeature "screenshot taking" media-gfx/scrot
	optfeature "screenshot uploading" net-misc/curl
	optfeature "resolution detection" x11-apps/xdpyinfo
}
