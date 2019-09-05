# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MY_PN="${PN/f/F}"

DESCRIPTION="Bash Screenshot Information Tool"
HOMEPAGE="https://github.com/KittyKatt/screenFetch"

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/KittyKatt/screenFetch.git"
	inherit git-r3
else
	KEYWORDS="amd64 ~arm x86 ~x64-macos"
	SRC_URI="${HOMEPAGE}/archive/v${PV}.tar.gz -> ${P}.tar.gz"
	S="${WORKDIR}/${MY_PN}-${PV}"
fi

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

src_install() {
	newbin ${PN}-dev ${PN}
	einstalldocs
}
