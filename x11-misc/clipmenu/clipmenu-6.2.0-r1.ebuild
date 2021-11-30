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
IUSE="+launcher"

RDEPEND="
	x11-misc/clipnotify
	x11-misc/xsel
	launcher? ( || ( x11-misc/dmenu x11-misc/rofi app-shells/fzf ) )
"

src_compile() {
	:
}

src_install() {
	local binfile
	for binfile in clipctl clipdel clipfsck clipmenu clipmenud; do
		dobin ${binfile}
	done

	dodoc README.md

	systemd_douserunit "init/clipmenud.service"
}

pkg_postinst() {
	if ! use launcher ; then
		ewarn "Clipmenu has been installed without a launcher."
		ewarn "You will need to set \$CM_LAUNCHER to a dmenu-compatible app for clipmenu to work."
		ewarn "Please refer to the documents for more info."
	fi
}
