# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Sub-meta package for the core applications integrated with GNOME"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="+bluetooth cups"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="amd64 ~arm arm64 ~loong ~ppc64 ~riscv x86"

# gnome-color-manager min version enforced here due to control-center pulling it in
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]

	>=gnome-base/gnome-session-44.0
	>=gnome-base/gnome-settings-daemon-44.1[cups?]
	>=gnome-base/gnome-control-center-44.3[cups?]
	>=gnome-extra/gnome-color-manager-3.36.0

	>=app-crypt/gcr-3.41.1:0
	>=app-crypt/gcr-4.1.0:4
	>=gnome-base/nautilus-44.2.1
	>=gnome-base/gnome-keyring-42.1
	>=gnome-extra/evolution-data-server-3.48.4

	|| (
		>=app-editors/gnome-text-editor-44.0
		>=app-editors/gedit-44
	)
	>=app-text/evince-44.3
	>=gnome-extra/gnome-contacts-44.0
	>=media-gfx/eog-44.3
	>=media-video/totem-43.0
	|| (
		>=x11-terms/gnome-terminal-3.48.2
		>=gui-apps/gnome-console-44.4
	)

	>=gnome-extra/gnome-user-docs-44.3
	>=gnome-extra/yelp-42.2

	>=x11-themes/adwaita-icon-theme-44.0

	bluetooth? ( >=net-wireless/gnome-bluetooth-42.5 )
"
DEPEND=""
BDEPEND=""

# cdr? ( >=app-cdr/brasero-3.12.2 ) # not part of gnome releng release anymore
# >=gnome-base/gnome-menus-3.13.3:3  # not used by core gnome anymore, just gnome-classic extensions

S="${WORKDIR}"
