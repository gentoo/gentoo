# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual for Wine that supports multiple variants and slotting"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="d3d9 staging"

# Note, the ordering here is intentional, to take advantage of the short-circuit
# logic of portage, to enforce wine-vanilla as default for new users.  The idea
# behind this is that some USE flags may pull in 3rd-party patchsets, so default
# of vanilla prevents that.
RDEPEND="
	staging? ( || (
		app-emulation/wine-staging[staging]
		app-emulation/wine-any[staging]
	) )
	d3d9? ( || (
		app-emulation/wine-d3d9[d3d9]
		app-emulation/wine-any[d3d9]
	) )
	|| (
		app-emulation/wine-vanilla
		app-emulation/wine-staging
		app-emulation/wine-d3d9
		app-emulation/wine-any
	)
	!app-emulation/wine:0"
