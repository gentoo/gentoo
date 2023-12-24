# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Sub-meta package for the core applications integrated with GNOME"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="+bluetooth cups"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~amd64 ~arm ~arm64 ~loong ~ppc64 ~riscv ~x86"

# gnome-color-manager min version enforced here due to control-center pulling it in
# glib-networking min version enforced as multiple other deps here rely on it (e.g. via libsoup)
# TODO: Replace eog with loupe
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]

	>=gnome-base/gnome-session-45.0
	>=gnome-base/gnome-settings-daemon-45.0[cups?]
	>=gnome-base/gnome-control-center-45.1[cups?]
	>=gnome-extra/gnome-color-manager-3.36.0

	>=app-crypt/gcr-3.41.1:0
	>=app-crypt/gcr-4.1.0:4
	>=gnome-base/nautilus-45.2
	>=gnome-base/gnome-keyring-42.1
	>=gnome-extra/evolution-data-server-3.50.2
	>=net-libs/glib-networking-2.78.0

	|| (
		>=app-editors/gnome-text-editor-45.1
		>=app-editors/gedit-46.1
	)
	>=app-text/evince-45.0
	>=gnome-extra/gnome-contacts-45.0
	>=media-gfx/eog-45.1
	>=media-video/totem-43.0
	|| (
		>=x11-terms/gnome-terminal-3.50.1
		>=gui-apps/gnome-console-45.0
	)

	>=gnome-extra/gnome-user-docs-45.1
	>=gnome-extra/yelp-42.2

	>=x11-themes/adwaita-icon-theme-45.0

	bluetooth? ( >=net-wireless/gnome-bluetooth-42.7 )
"
DEPEND=""
BDEPEND=""

# cdr? ( >=app-cdr/brasero-3.12.2 ) # not part of gnome releng release anymore
# >=gnome-base/gnome-menus-3.13.3:3  # not used by core gnome anymore, just gnome-classic extensions

S="${WORKDIR}"
