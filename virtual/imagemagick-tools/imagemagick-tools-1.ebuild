# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for imagemagick command line tools"

SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86 ~arm64-macos ~x64-macos ~x64-solaris"
IUSE="jpeg perl postscript png svg tiff"

# This virtual is to be used **ONLY** for depending on the runtime
# tools of imagemagick/graphicsmagick. It should and cannot be used
# for linking against, as subslots are not transitively passed on.
# For linking, you will need to depend on the respective libraries
# in all consuming ebuilds and use appropriate sub-slot operators.
# See also: https://bugs.gentoo.org/314431
RDEPEND="
	svg? (
		media-gfx/imagemagick[jpeg?,perl?,postscript?,png?,svg,tiff?]
	)
	!svg? (
		|| (
			media-gfx/imagemagick[jpeg?,perl?,postscript?,png?,tiff?]
			media-gfx/graphicsmagick[imagemagick,jpeg?,perl?,postscript?,png?,tiff?]
		)
	)
"
