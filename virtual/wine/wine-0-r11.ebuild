# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual to depend on any app-emulation/wine-* variant"

SLOT="0"
KEYWORDS="amd64 ~arm64 x86"
IUSE="+abi_x86_32 +abi_x86_64"

# wow64 provides 32+64bit support
RDEPEND="
	|| (
		app-emulation/wine-vanilla[abi_x86_32?,abi_x86_64?]
		app-emulation/wine-staging[abi_x86_32?,abi_x86_64?]
		app-emulation/wine-proton[abi_x86_32?,abi_x86_64?]
		app-emulation/wine-vanilla[wow64(-)]
		app-emulation/wine-staging[wow64(-)]
		app-emulation/wine-proton[wow64(-)]
	)
"
