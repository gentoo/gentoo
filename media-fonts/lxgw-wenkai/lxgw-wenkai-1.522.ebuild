# Copyright 2022-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit font

DESCRIPTION="An open-source Chinese font derived from Fontworks' Klee One"
HOMEPAGE="https://github.com/lxgw/LxgwWenKai https://github.com/lxgw/LxgwWenKai-Screen"
SRC_URI="
	https://github.com/lxgw/LxgwWenKai/releases/download/v${PV}/${PN}-v${PV}.tar.gz -> ${P}.tar.gz
	screen? (
		https://github.com/lxgw/LxgwWenKai-Screen/releases/download/v${PV}/LXGWWenKaiScreen.ttf -> ${PN}-screen-${PV}.ttf
		https://github.com/lxgw/LxgwWenKai-Screen/releases/download/v${PV}/LXGWWenKaiMonoScreen.ttf
			-> ${PN}-mono-screen-${PV}.ttf
	)
"

S="${WORKDIR}/${PN}-v${PV}"

LICENSE="OFL-1.1"
SLOT="0"
KEYWORDS="~amd64 ~loong"

IUSE="screen"

FONT_SUFFIX="ttf"

src_unpack() {
	unpack "${P}.tar.gz"

	if use screen; then
		cp "${DISTDIR}/${PN}-screen-${PV}.ttf" "${S}/LXGWWenKaiScreen.ttf"
		cp "${DISTDIR}/${PN}-mono-screen-${PV}.ttf" "${S}/LXGWWenKaiMonoScreen.ttf"
	fi
}
