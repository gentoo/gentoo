# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit systemd

DESCRIPTION="Clipboard management using dmenu"
HOMEPAGE="https://github.com/cdown/clipmenu"
SRC_URI="https://github.com/cdown/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""

RDEPEND="
	x11-misc/clipnotify
	x11-misc/dmenu
	x11-misc/xsel
"

src_compile() {
	:
}

src_install() {
	local binfile
	for binfile in clipctl clipdel clipfsck clipmenu clipmenud; do
		dobin ${binfile}
	done

	systemd_douserunit "init/clipmenud.service"
}
