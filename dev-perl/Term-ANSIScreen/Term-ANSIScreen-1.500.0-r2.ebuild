# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=AUDREYT
DIST_VERSION=1.50
inherit perl-module

DESCRIPTION="Terminal control using ANSI escape sequences"

LICENSE="CC0-1.0"
SLOT="0"
KEYWORDS="amd64 ~hppa ~ppc x86"

PATCHES=( "${FILESDIR}"/${PN}-1.50-no-dot-inc.patch )
