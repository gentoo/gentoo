# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib-build

DESCRIPTION="Virtual for JACK Audio Connection Kit"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~m68k ~mips ppc ppc64 s390 sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~sparc-solaris"

RDEPEND="
	|| (
		>=media-sound/jack-audio-connection-kit-0.121.3-r1[${MULTILIB_USEDEP}]
		media-sound/jack2[${MULTILIB_USEDEP}]
	)"
