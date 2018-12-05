# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MONS
DIST_VERSION="0.05"

inherit perl-module

DESCRIPTION="Enhancing Test::More for UTF8-based projects"

SLOT="0"
LICENSE="|| ( Artistic GPL-1+ )"
KEYWORDS="~alpha ~amd64 ~hppa ~ppc ~x86 ~ppc-macos"

IUSE=""

DEPEND="dev-lang/perl"
