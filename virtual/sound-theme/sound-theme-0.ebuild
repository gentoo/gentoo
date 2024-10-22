# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for themes following the freedesktop.org sound naming spec"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~mips ppc ppc64 ~riscv ~s390 sparc x86 ~amd64-linux ~x86-linux"
IUSE="+sound"

RDEPEND="
	sound? ( || (
		x11-themes/sound-theme-freedesktop
		kde-plasma/ocean-sound-theme:*
		>=kde-plasma/oxygen-sounds-6.0.0:*
	) )
"
