# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

MY_PN="${PN/f/F}"

DESCRIPTION="Bash Screenshot Information Tool"
HOMEPAGE="https://github.com/KittyKatt/screenFetch"

LICENSE="GPL-3"
SLOT="0"
IUSE="curl X"

DEPEND=""
RDEPEND="
	curl? ( net-misc/curl )
	X? (
		media-gfx/scrot
		x11-apps/xdpyinfo
	)"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="git://github.com/KittyKatt/screenFetch.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~x86"
	SRC_URI="https://github.com/KittyKatt/${MY_PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

src_install() {
	newbin ${PN}-dev ${PN}
	einstalldocs
}
