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

	>=gnome-base/gnome-session-40.1.1
	>=gnome-base/gnome-settings-daemon-41.0[cups?]
	>=gnome-base/gnome-control-center-41.2[cups?]
	>=gnome-extra/gnome-color-manager-3.36.0

	>=app-crypt/gcr-3.40.0
	>=gnome-base/nautilus-41.1
	>=gnome-base/gnome-keyring-40.0
	>=gnome-extra/evolution-data-server-3.42.3

	>=app-crypt/seahorse-41.0
	>=app-editors/gedit-41
	>=app-text/evince-41.3
	>=gnome-extra/gnome-contacts-41.0
	>=media-gfx/eog-41.1
	>=media-video/totem-3.38.2
	>=x11-terms/gnome-terminal-3.42.2

	>=gnome-extra/gnome-user-docs-41.1
	>=gnome-extra/yelp-41.2

	>=x11-themes/adwaita-icon-theme-41.0

	bluetooth? ( >=net-wireless/gnome-bluetooth-3.34.5 )
"
DEPEND=""
BDEPEND=""

# cdr? ( >=app-cdr/brasero-3.12.2 ) # not part of gnome releng release anymore
# >=gnome-base/gnome-menus-3.13.3:3  # not used by core gnome anymore, just gnome-classic extensions
# >=net-im/empathy-3.12.12 # not part of gnome releng core or apps suite anymore

S="${WORKDIR}"
