# Copyright 2020-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit optfeature systemd

DESCRIPTION="Clipboard management"
HOMEPAGE="https://github.com/cdown/clipmenu"
SRC_URI="https://github.com/cdown/${PN}/archive/${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Unlicense"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+dmenu fzf rofi"
REQUIRED_USE="?? ( dmenu fzf rofi )"

RDEPEND="
	x11-misc/clipnotify
	x11-misc/xsel
	dmenu? ( x11-misc/dmenu )
	fzf? ( app-shells/fzf )
	rofi? ( x11-misc/rofi )
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
	optfeature "ignoring specific windows via CM_IGNORE_WINDOW" x11-misc/xdotool

	if systemd_is_booted || has_version sys-apps/systemd; then
		einfo ""
		einfo "Make sure to import \$DISPLAY when using the systemd unit for clipmenud"
		einfo "without a desktop environment. Preferably check /etc/X11/xinit/xinitrc{,.d}"
		einfo "for relevant examples, or at least include the following in your ~/.xinitrc"
		einfo "before clipmenud:"
		einfo ""
		einfo "systemctl --user import-environment DISPLAY"
	fi

	if ! use dmenu && ! use fzf && ! use rofi ; then
		ewarn ""
		ewarn "Clipmenu has been installed without a launcher."
		ewarn "You will need to set \$CM_LAUNCHER to a dmenu-compatible app for clipmenu to work."
		ewarn "Please refer to the documents for more info."
	fi
}
