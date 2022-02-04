# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RUITTENB
DIST_VERSION=1.20
inherit perl-module

DESCRIPTION="A Term::Screen based screen positioning and coloring module"

SLOT="0"
KEYWORDS="amd64 ~s390 x86"

RDEPEND="
	>=dev-perl/Term-Screen-1.30.0
"
BDEPEND="${RDEPEND}
"

# Tests require a real tty device attached to stdin
DIST_TEST=skip
