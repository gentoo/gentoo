# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eapi7-ver

P_RELEASE="$(ver_cut 1-2)"

DESCRIPTION="Meta package for GNOME-Light, merge this package to install"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="2.0"
IUSE="cups +gnome-shell"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="amd64 ~arm ~ppc ~ppc64 x86"

# XXX: Note to developers:
# This is a wrapper for the 'light' GNOME 3 desktop, and should only consist of
# the bare minimum of libs/apps needed. It is basically gnome-base/gnome without
# any apps, but shouldn't be used by users unless they know what they are doing.
# cantarell minimum version is ensured here as gnome-shell depends on it.
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]

	>=gnome-base/gnome-session-3.30.1
	>=gnome-base/gnome-settings-daemon-3.30.1.2[cups?]
	>=gnome-base/gnome-control-center-${PV}[cups?]

	>=gnome-base/nautilus-${PV}

	gnome-shell? (
		>=x11-wm/mutter-${PV}
		>=dev-libs/gjs-1.54.2
		>=gnome-base/gnome-shell-${PV}
		>=media-fonts/cantarell-0.111 )

	>=x11-themes/adwaita-icon-theme-${P_RELEASE}
	>=x11-themes/gnome-themes-standard-3.28
	>=x11-themes/gnome-backgrounds-${P_RELEASE}

	>=x11-terms/gnome-terminal-${PV}
"
DEPEND=""
PDEPEND=">=gnome-base/gvfs-1.38.1"
S="${WORKDIR}"

pkg_pretend() {
	if ! use gnome-shell; then
		# Users probably want to use e16, sawfish, etc
		ewarn "You're not installing GNOME Shell"
		ewarn "You will have to install and manage a window manager by yourself"
	fi
}

pkg_postinst() {
	# Remember people where to find our project information
	elog "Please remember to look at https://wiki.gentoo.org/wiki/Project:GNOME"
	elog "for information about the project and documentation."
}
