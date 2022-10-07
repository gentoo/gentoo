# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Virtual for Wine that supports multiple variants and slotting"

SLOT="0"
KEYWORDS="amd64 x86"
IUSE="+abi_x86_32 +abi_x86_64 staging"

REQUIRED_USE="|| ( abi_x86_32 abi_x86_64 )"

# Note, the ordering here is intentional, to take advantage of the short-circuit
# logic of portage, to enforce wine-vanilla as default for new users.  The idea
# behind this is that some USE flags may pull in 3rd-party patchsets, so default
# of vanilla prevents that.
RDEPEND="
	staging? ( || (
		app-emulation/wine-staging[staging(+)]
	) )
	|| (
		app-emulation/wine-vanilla[abi_x86_32=,abi_x86_64=]
		app-emulation/wine-staging[abi_x86_32=,abi_x86_64=]
	)"
