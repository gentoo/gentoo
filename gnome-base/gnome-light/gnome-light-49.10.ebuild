# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta package for GNOME-Light, merge this package to install"
HOMEPAGE="https://www.gnome.org/"

S=${WORKDIR}

LICENSE="metapackage"
SLOT="2.0"
KEYWORDS="~amd64 ~arm ~arm64 ~riscv ~x86"

IUSE="cups +gnome-shell"

# XXX: Note to developers:
# This is a wrapper for the 'light' GNOME desktop, and should only consist of
# the bare minimum of libs/apps needed. It is basically gnome-base/gnome without
# any apps, but shouldn't be used by users unless they know what they are doing.
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]

	>=gnome-base/gnome-session-49.3
	>=gnome-base/gnome-settings-daemon-49.1[cups?]
	>=gnome-base/gnome-control-center-49.9[cups?]

	>=gnome-base/nautilus-49.6

	gnome-shell? (
		>=x11-wm/mutter-49.8
		>=dev-libs/gjs-1.85.90
		>=gnome-base/gnome-shell-49.10
		>=media-fonts/adwaita-fonts-49
	)

	>=x11-themes/adwaita-icon-theme-49.0
	>=x11-themes/gnome-backgrounds-49.10

	|| (
		>=gui-apps/gnome-console-49.2
		>=x11-terms/ptyxis-49.3
		>=x11-terms/gnome-terminal-3.56
	)
"
PDEPEND=">=gnome-base/gvfs-1.58.5"

pkg_pretend() {
	if ! use gnome-shell; then
		# Users probably want to use gnome-flashback, e16, sawfish, etc
		ewarn "You're not installing GNOME Shell"
		ewarn "You will have to install and manage a window manager by yourself"
	fi
}

pkg_postinst() {
	# Remind people where to find our project information
	elog "Please remember to look at https://wiki.gentoo.org/wiki/Project:GNOME"
	elog "for information about the project and documentation."
}
