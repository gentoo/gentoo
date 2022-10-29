# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JESSE
DIST_VERSION=0.27
inherit perl-module

DESCRIPTION="A lightweight cache with timed expiration"
SLOT="0"
KEYWORDS="~alpha amd64 ~hppa ~ia64 ppc ~riscv sparc x86"

PATCHES=(
	"${FILESDIR}/${PN}-0.27-no-dot-inc.patch"
)
