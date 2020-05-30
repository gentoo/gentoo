# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

P_RELEASE="$(ver_cut 1-2)"

DESCRIPTION="Meta package for GNOME-Light, merge this package to install"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="2.0"
IUSE="cups +gnome-shell"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="amd64 ~arm ~ia64 ~ppc ~ppc64 x86"

# XXX: Note to developers:
# This is a wrapper for the 'light' GNOME 3 desktop, and should only consist of
# the bare minimum of libs/apps needed. It is basically gnome-base/gnome without
# any apps, but shouldn't be used by users unless they know what they are doing.
# cantarell minimum version is ensured here as gnome-shell depends on it.
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]

	>=gnome-base/gnome-session-3.34.2
	>=gnome-base/gnome-settings-daemon-3.34.2[cups?]
	>=gnome-base/gnome-control-center-${PV}[cups?]

	>=gnome-base/nautilus-3.34.2

	gnome-shell? (
		>=x11-wm/mutter-${PV}
		>=dev-libs/gjs-1.58.5
		>=gnome-base/gnome-shell-${PV}
		>=media-fonts/cantarell-0.111 )

	>=x11-themes/adwaita-icon-theme-3.32.0
	>=x11-themes/gnome-themes-standard-3.28
	>=x11-themes/gnome-backgrounds-${P_RELEASE}

	>=x11-terms/gnome-terminal-3.34.2
"
# adwaita-icon-theme kept back on purpose due to brokenness without rust librsvg,
# in the hope that the old icon package version is good enough for everything too
# until librsvg gets updated. This dep should be raised to 3.34 with 3.34.5 meta.
DEPEND=""
PDEPEND=">=gnome-base/gvfs-1.42.2"
BDEPEND=""
S="${WORKDIR}"

pkg_pretend() {
	if ! use gnome-shell; then
		# Users probably want to use gnome-flashback, e16, sawfish, etc
		ewarn "You're not installing GNOME Shell"
		ewarn "You will have to install and manage a window manager by yourself"
	fi
}

pkg_postinst() {
	# Remember people where to find our project information
	elog "Please remember to look at https://wiki.gentoo.org/wiki/Project:GNOME"
	elog "for information about the project and documentation."
}
