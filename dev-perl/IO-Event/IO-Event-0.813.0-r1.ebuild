# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=MUIR
DIST_VERSION=0.813
DIST_SECTION=modules
inherit perl-module

DESCRIPTION="Tied Filehandles for Nonblocking IO with Object Callbacks"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="
	dev-perl/AnyEvent
	dev-perl/Event
	dev-perl/List-MoreUtils
	virtual/perl-Time-HiRes
"
DEPEND="${RDEPEND}"

PATCHES=( "${FILESDIR}/${P}-forked2.t.patch" )
