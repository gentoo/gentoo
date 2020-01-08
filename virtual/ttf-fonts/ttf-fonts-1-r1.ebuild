# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual for Serif/Sans/Monospace font packages"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 ~mips ppc ppc64 s390 sh sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="|| (
		media-fonts/liberation-fonts
		media-fonts/source-pro
		media-fonts/dejavu
		media-fonts/croscorefonts
		media-fonts/droid
		media-fonts/freefont
		media-fonts/corefonts
	)"
