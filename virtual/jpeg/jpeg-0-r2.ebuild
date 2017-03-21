# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit multilib-build

DESCRIPTION="A virtual for selecting between libjpeg-turbo and IJG jpeg for source-based packages"
HOMEPAGE=""
SRC_URI=""

LICENSE=""
SLOT="0"
KEYWORDS="alpha amd64 arm arm64 hppa ia64 m68k ~mips ppc ppc64 s390 sh sparc x86 ~x64-cygwin ~amd64-fbsd ~sparc-fbsd ~x86-fbsd ~amd64-linux ~arm-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="static-libs"

RDEPEND="|| (
		>=media-libs/libjpeg-turbo-1.3.0-r3:0[static-libs?,${MULTILIB_USEDEP}]
		>=media-libs/jpeg-8d-r1:0[static-libs?,${MULTILIB_USEDEP}]
		)"
DEPEND=""
