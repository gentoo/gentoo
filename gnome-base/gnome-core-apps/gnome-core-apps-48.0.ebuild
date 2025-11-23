# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Sub-meta package for the core applications integrated with GNOME"
HOMEPAGE="https://www.gnome.org/"

S="${WORKDIR}"

LICENSE="metapackage"
SLOT="3.0"
KEYWORDS="amd64"

IUSE="+bluetooth cups"

DEPEND=""
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]

	>=gnome-base/gnome-session-${PV}
	>=gnome-base/gnome-settings-daemon-${PV}[cups?]
	>=gnome-base/gnome-control-center-${PV}[cups?]
	>=gnome-extra/gnome-color-manager-3.36.2

	>=app-crypt/gcr-3.41.2:0
	>=app-crypt/gcr-4.4:4
	>=gnome-base/nautilus-${PV}
	>=gnome-base/gnome-keyring-${PV}
	>=gnome-extra/evolution-data-server-3.56
	>=net-libs/glib-networking-2.80.1

	|| (
		>=app-editors/gnome-text-editor-${PV}
		>=app-editors/gedit-${PV}
	)
	>=app-text/papers-${PV}
	>=gnome-extra/gnome-contacts-47.1.1
	|| (
		>=media-gfx/loupe-${PV}
		>=media-gfx/eog-47.0
	)
	>=media-video/totem-43.1
	|| (
		>=gui-apps/gnome-console-${PV}
		>=x11-terms/gnome-terminal-3.56
	)

	>=gnome-extra/gnome-user-docs-${PV}
	>=gnome-extra/yelp-42.3

	>=x11-themes/adwaita-icon-theme-${PV}

	bluetooth? ( >=net-wireless/gnome-bluetooth-47.1 )
"
BDEPEND=""
