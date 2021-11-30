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
IUSE="+dmenu rofi fzf"
REQUIRED_USE="?? ( dmenu rofi fzf )"

RDEPEND="
	x11-misc/clipnotify
	x11-misc/xsel
	dmenu? ( x11-misc/dmenu )
	rofi? ( x11-misc/rofi )
	fzf? ( app-shells/fzf )
"

src_prepare() {
	default

	if use rofi ; then
		sed -i 's|CM_LAUNCHER=dmenu|CM_LAUNCHER=rofi|' clipmenu || die "sed failed"
	elif use fzf ; then
		sed -i 's|CM_LAUNCHER=dmenu|CM_LAUNCHER=fzf|' clipmenu || die "sed failed"
	fi
}

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
	if ! use dmenu && ! use rofi && ! use fzf ; then
		ewarn "Clipmenu has been installed without a launcher."
		ewarn "You will need to set \$CM_LAUNCHER to a dmenu-compatible app for clipmenu to work."
		ewarn "Please refer to the documents for more info."
	fi
}
