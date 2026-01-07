# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-build

DESCRIPTION="Virtual for JACK Audio Connection Kit"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~loong ~mips ppc ppc64 ~riscv ~sparc x86 ~x64-macos"

RDEPEND="
	|| (
		media-sound/jack2[${MULTILIB_USEDEP}]
		media-sound/jack-audio-connection-kit[${MULTILIB_USEDEP}]
		media-video/pipewire[${MULTILIB_USEDEP},jack-sdk(-)]
	)"
