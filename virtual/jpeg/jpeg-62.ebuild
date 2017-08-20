# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib-build

DESCRIPTION="A virtual for the libjpeg.so.62 ABI for binary-only programs"
SLOT="62"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"

RDEPEND="|| (
		>=media-libs/libjpeg-turbo-1.3.0-r3:0[${MULTILIB_USEDEP}]
		>=media-libs/jpeg-6b-r12:62[${MULTILIB_USEDEP}]
		)"
