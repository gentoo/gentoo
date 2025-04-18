# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Sub-meta package for the core applications integrated with GNOME"
HOMEPAGE="https://www.gnome.org/"
S="${WORKDIR}"

LICENSE="metapackage"
SLOT="3.0"
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"
IUSE="+bluetooth cups"

# gnome-color-manager min version enforced here due to control-center pulling it in
# glib-networking min version enforced as multiple other deps here rely on it (e.g. via libsoup)
# TODO: Replace eog with loupe
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]

	>=gnome-base/gnome-session-47.0.1
	>=gnome-base/gnome-settings-daemon-47.2[cups?]
	>=gnome-base/gnome-control-center-47.3[cups?]
	>=gnome-extra/gnome-color-manager-3.36.0

	>=app-crypt/gcr-3.41.1:0
	>=app-crypt/gcr-4.3.0:4
	>=gnome-base/nautilus-47.1
	>=gnome-base/gnome-keyring-46.2
	>=gnome-extra/evolution-data-server-3.54.3
	>=net-libs/glib-networking-2.80.1

	|| (
		>=app-editors/gnome-text-editor-47.2
		>=app-editors/gedit-46.2
	)
	>=app-text/evince-46.3.1
	>=gnome-extra/gnome-contacts-47.1.1
	>=media-gfx/eog-47.0
	>=media-video/totem-43.1
	|| (
		>=x11-terms/gnome-terminal-3.54.3
		>=gui-apps/gnome-console-47.1
	)

	>=gnome-extra/gnome-user-docs-47.2
	>=gnome-extra/yelp-42.2

	>=x11-themes/adwaita-icon-theme-47.0

	bluetooth? ( >=net-wireless/gnome-bluetooth-47.1 )
"
DEPEND=""
BDEPEND=""
