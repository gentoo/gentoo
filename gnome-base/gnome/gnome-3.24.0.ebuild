# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Meta package for GNOME 3, merge this package to install"
HOMEPAGE="https://www.gnome.org/"

LICENSE="metapackage"
SLOT="2.0" # Cannot be installed at the same time as gnome-2

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="~amd64 ~x86"

IUSE="accessibility +bluetooth +classic +cdr cups +extras"

S=${WORKDIR}

# TODO: check accessibility completeness
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]
	>=gnome-base/gnome-core-apps-${PV}[cups?,bluetooth?,cdr?]

	>=gnome-base/gdm-${PV}

	>=x11-wm/mutter-${PV}
	>=gnome-base/gnome-shell-${PV}[bluetooth?]

	>=x11-themes/gnome-backgrounds-${PV}
	x11-themes/sound-theme-freedesktop

	accessibility? (
		>=app-accessibility/at-spi2-atk-2.24
		>=app-accessibility/at-spi2-core-2.24
		>=app-accessibility/caribou-0.4.21
		>=app-accessibility/orca-${PV}
		>=gnome-extra/mousetweaks-3.12.0 )
	classic? ( >=gnome-extra/gnome-shell-extensions-${PV} )
	extras? ( >=gnome-base/gnome-extra-apps-${PV} )
"

DEPEND=""

PDEPEND=">=gnome-base/gvfs-1.30.2[udisks]"

pkg_postinst() {
	# Remember people where to find our project information
	elog "Please remember to look at https://wiki.gentoo.org/wiki/Project:GNOME"
	elog "for information about the project and documentation."
}
