# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BRTASTIC
DIST_VERSION=0.09
inherit perl-module

DESCRIPTION="Module that 'unblesses' Perl objects"

SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND=""
BDEPEND="${RDEPEND}
	test? ( dev-perl/Test-Exception )
"

PATCHES=( "${FILESDIR}/${PN}-0.08-respect-cflags.patch" )
