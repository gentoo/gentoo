# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Sub-meta package for the core applications integrated with GNOME 3"
HOMEPAGE="https://www.gnome.org/"
LICENSE="metapackage"
SLOT="3.0"
IUSE="+bluetooth cups"

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="amd64 ~arm ~arm64 ~ia64 ~ppc ~ppc64 x86"

# gnome-color-manager min version enforced here due to control-center pulling it in
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]

	>=gnome-base/gnome-session-3.30.1
	>=gnome-base/gnome-settings-daemon-3.30.1.2[cups?]
	>=gnome-base/gnome-control-center-3.30.1[cups?]
	>=gnome-extra/gnome-color-manager-3.30.0

	>=app-crypt/gcr-3.28.0
	>=gnome-base/nautilus-${PV}
	>=gnome-base/gnome-keyring-3.28.2
	>=gnome-extra/evolution-data-server-${PV}

	>=app-crypt/seahorse-3.30.1.1
	>=app-editors/gedit-${PV}
	>=app-text/evince-${PV}
	>=gnome-extra/gnome-contacts-3.30.1
	>=media-gfx/eog-3.28.4
	>=media-video/totem-3.30.0
	>=x11-terms/gnome-terminal-${PV}

	>=gnome-extra/gnome-user-docs-${PV}
	>=gnome-extra/yelp-3.30.0

	>=x11-themes/adwaita-icon-theme-3.30.0

	bluetooth? ( >=net-wireless/gnome-bluetooth-3.28.2 )
"
DEPEND=""

# cdr? ( >=app-cdr/brasero-3.12.2 ) # not part of gnome releng release anymore
# >=gnome-base/gnome-menus-3.13.3:3  # not used by core gnome anymore, just gnome-classic extensions
# >=net-im/empathy-3.12.12 # not part of gnome releng core or apps suite anymore

S="${WORKDIR}"
