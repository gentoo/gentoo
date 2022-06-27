# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-build

DESCRIPTION="Virtual for JACK Audio Connection Kit"
SLOT="0"
KEYWORDS="amd64 arm arm64 ~ia64 ~loong ~mips ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~sparc-solaris"

RDEPEND="
	|| (
		media-sound/jack2[${MULTILIB_USEDEP}]
		media-sound/jack-audio-connection-kit[${MULTILIB_USEDEP}]
		media-video/pipewire[${MULTILIB_USEDEP},jack-sdk(-)]
	)"
