# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JRED
DIST_VERSION=0.64
inherit perl-module

DESCRIPTION="High level API for event-based execution flow control"

LICENSE="|| ( Artistic GPL-1+ ) LGPL-2.1+"
SLOT="0"
KEYWORDS="amd64 ppc ppc64 sparc x86"

RDEPEND="
	>=dev-perl/AnyEvent-0.400.0
	dev-perl/libintl-perl
"
BDEPEND="${RDEPEND}"
