# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta package for GNOME, merge this package to install"
HOMEPAGE="https://www.gnome.org/"
S=${WORKDIR}

LICENSE="metapackage"
SLOT="2.0" # Cannot be installed at the same time as gnome-2
KEYWORDS="~amd64 ~arm64 ~loong ~riscv ~x86"

IUSE="accessibility +bluetooth +classic cups +extras"

# TODO: check accessibility completeness
RDEPEND="
	>=gnome-base/gnome-core-libs-${PV}[cups?]
	>=gnome-base/gnome-core-apps-${PV}[cups?,bluetooth?]

	>=gnome-base/gdm-47.0

	>=x11-wm/mutter-47.4
	>=gnome-base/gnome-shell-47.3
	>=media-fonts/cantarell-0.303.1

	>=x11-themes/gnome-backgrounds-47.0
	x11-themes/sound-theme-freedesktop

	accessibility? (
		>=app-accessibility/at-spi2-core-2.54.0
		>=app-accessibility/orca-47.3
		>=gnome-extra/mousetweaks-3.32.0
	)
	classic? ( >=gnome-extra/gnome-shell-extensions-47.3 )
	extras? ( >=gnome-base/gnome-extra-apps-${PV} )
"
PDEPEND=">=gnome-base/gvfs-1.56.1[udisks]"

DEPEND=""
BDEPEND=""

pkg_postinst() {
	# Remind people where to find our project information
	elog "Please remember to look at https://wiki.gentoo.org/wiki/Project:GNOME"
	elog "for information about the project and documentation."
}
