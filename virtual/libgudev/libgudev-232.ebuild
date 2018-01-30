# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit multilib-build

DESCRIPTION="Virtual for libgudev providers"
SLOT="0/0"
KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~m68k ~mips ~ppc ~ppc64 ~s390 ~sh sparc x86"
IUSE="introspection static-libs"

RDEPEND=">=dev-libs/libgudev-232:0/0[${MULTILIB_USEDEP},introspection?,static-libs?]"
