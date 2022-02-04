# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=CLKAO
DIST_VERSION=0.10
inherit perl-module

DESCRIPTION="Represent a series of changes in annotate form"

SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"

RDEPEND=">=dev-perl/Algorithm-Diff-1.150.0"
BDEPEND="${RDEPEND}"
