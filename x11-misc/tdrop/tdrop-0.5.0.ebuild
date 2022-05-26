# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature

DESCRIPTION="WM-Independent Dropdown Creator"
HOMEPAGE="https://github.com/noctuid/tdrop"

if [[ ${PV} == "9999" ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/noctuid/tdrop"
else
	SRC_URI="https://github.com/noctuid/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64 ~ppc64"
fi

LICENSE="BSD-2"
SLOT="0"
IUSE=""

RDEPEND="
	app-shells/bash
	sys-apps/gawk
	sys-process/procps
	x11-apps/xprop
	x11-apps/xrandr
	x11-apps/xwininfo
	x11-misc/xdotool
"

src_compile() {
	:
}

src_install() {
	dobin tdrop
	doman tdrop.1
	dodoc README.org
}

pkg_postinst() {
	optfeature "tmux session support" app-misc/tmux
}
