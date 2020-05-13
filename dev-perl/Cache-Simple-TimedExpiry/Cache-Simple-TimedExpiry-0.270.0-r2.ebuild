# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=JESSE
DIST_VERSION=0.27
inherit perl-module

DESCRIPTION="A lightweight cache with timed expiration"
# License note: no formal upstream license declaration
# only an assumed one from 'license => perl' in Makefile.PL
# Bug: https://bugs.gentoo.org/722854
SLOT="0"
KEYWORDS="~alpha ~amd64 ~hppa ~ia64 ~ppc ~sparc ~x86"
PATCHES=(
	"${FILESDIR}/${PN}-0.27-no-dot-inc.patch"
)
