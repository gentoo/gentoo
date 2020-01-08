# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-build

DESCRIPTION="Virtual to select between libjpeg-turbo and IJG jpeg for source-based packages"
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x64-cygwin ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND="|| (
		>=media-libs/libjpeg-turbo-1.5.3-r2:0[static-libs?,${MULTILIB_USEDEP}]
		>=media-libs/jpeg-9c:0[static-libs?,${MULTILIB_USEDEP}]
		)"
