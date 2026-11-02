# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Sub-meta package for the core applications integrated with GNOME"
HOMEPAGE="https://www.gnome.org/"

S=${WORKDIR}

LICENSE="metapackage"
SLOT="3.0"
KEYWORDS="~amd64 ~arm64 ~ppc64 ~riscv ~x86"

IUSE="+bluetooth cups"

# gnome-color-manager min version enforced here due to control-center pulling it in
# glib-networking min version enforced as multiple other deps here rely on it (e.g. via libsoup)
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]

	>=gnome-base/gnome-session-49.3
	>=gnome-base/gnome-settings-daemon-49.1[cups?]
	>=gnome-base/gnome-control-center-49.9[cups?]
	>=gnome-extra/gnome-color-manager-3.36.2

	>=app-crypt/gcr-3.41.2:0
	>=app-crypt/gcr-4.4.1:4
	>=gnome-base/nautilus-49.6
	>=gnome-base/gnome-keyring-48.0
	>=gnome-extra/evolution-data-server-3.58.3
	>=net-libs/glib-networking-2.80.1

	|| (
		>=app-editors/gnome-text-editor-49.2
		>=app-editors/gedit-49.0
	)
	>=app-text/papers-49.8
	>=gnome-extra/gnome-contacts-49.0
	|| (
		>=media-gfx/loupe-49.2
		>=media-gfx/eog-49.3
	)
	>=media-video/totem-43.2
	|| (
		>=gui-apps/gnome-console-49.2
		>=x11-terms/ptyxis-49.3
		>=x11-terms/gnome-terminal-3.58.0
	)

	>=gnome-extra/gnome-user-docs-49.10
	>=gnome-extra/yelp-49.2

	>=x11-themes/adwaita-icon-theme-49.0

	bluetooth? ( >=net-wireless/gnome-bluetooth-47.2 )
"
