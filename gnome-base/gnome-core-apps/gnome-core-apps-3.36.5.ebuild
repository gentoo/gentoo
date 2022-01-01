# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Sub-meta package for the core applications integrated with GNOME 3"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="+bluetooth cups"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~amd64 ~arm ~arm64 ~ppc64 ~x86"

# gnome-color-manager min version enforced here due to control-center pulling it in
# tepl min version for gedit deptree
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]

	>=gnome-base/gnome-session-3.36.0
	>=gnome-base/gnome-settings-daemon-3.36.1[cups?]
	>=gnome-base/gnome-control-center-3.36.4[cups?]
	>=gnome-extra/gnome-color-manager-3.36.0

	>=app-crypt/gcr-3.36.0
	>=gnome-base/nautilus-3.36.3
	>=gnome-base/gnome-keyring-3.36.0
	>=gnome-extra/evolution-data-server-${PV}

	>=app-crypt/seahorse-3.36.2
	>=gui-libs/tepl-4.4.0
	>=app-editors/gedit-3.36.2
	>=app-text/evince-3.36.7
	>=gnome-extra/gnome-contacts-3.36.2
	>=media-gfx/eog-3.36.3
	>=media-video/totem-3.34.1
	>=x11-terms/gnome-terminal-3.36.2

	>=gnome-extra/gnome-user-docs-3.36.2
	>=gnome-extra/yelp-3.36.0

	>=x11-themes/adwaita-icon-theme-3.36.1

	bluetooth? ( >=net-wireless/gnome-bluetooth-3.34.1 )
"
DEPEND=""
BDEPEND=""

# cdr? ( >=app-cdr/brasero-3.12.2 ) # not part of gnome releng release anymore
# >=gnome-base/gnome-menus-3.13.3:3  # not used by core gnome anymore, just gnome-classic extensions
# >=net-im/empathy-3.12.12 # not part of gnome releng core or apps suite anymore

S="${WORKDIR}"
