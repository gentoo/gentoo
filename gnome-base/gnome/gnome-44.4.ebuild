# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Meta package for GNOME, merge this package to install"
HOMEPAGE="https://www.gnome.org/"

LICENSE="metapackage"
SLOT="2.0" # Cannot be installed at the same time as gnome-2

# when unmasking for an arch
# double check none of the deps are still masked !
KEYWORDS="amd64 arm64 ~loong ~ppc64 ~riscv x86"

IUSE="accessibility +bluetooth +classic cups +extras"

S=${WORKDIR}

# TODO: check accessibility completeness
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]
	>=gnome-base/gnome-core-apps-${PV}[cups?,bluetooth?]

	>=gnome-base/gdm-44.1

	>=x11-wm/mutter-44.3
	>=gnome-base/gnome-shell-44.3
	>=media-fonts/cantarell-0.303.1

	>=x11-themes/gnome-backgrounds-44.0
	x11-themes/sound-theme-freedesktop

	accessibility? (
		>=app-accessibility/at-spi2-core-2.48.3
		>=app-accessibility/orca-44.1
		>=gnome-extra/mousetweaks-3.32.0
	)
	classic? ( >=gnome-extra/gnome-shell-extensions-44.0 )
	extras? ( >=gnome-base/gnome-extra-apps-${PV} )
"
PDEPEND=">=gnome-base/gvfs-1.50.6[udisks]"

DEPEND=""
BDEPEND=""

pkg_postinst() {
	# Remind people where to find our project information
	elog "Please remember to look at https://wiki.gentoo.org/wiki/Project:GNOME"
	elog "for information about the project and documentation."
}
