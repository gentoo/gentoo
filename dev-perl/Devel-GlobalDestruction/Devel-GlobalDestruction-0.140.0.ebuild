# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=HAARG
DIST_VERSION=0.14
inherit perl-module

DESCRIPTION='Returns the equivalent of ${^GLOBAL_PHASE} eq DESTRUCT for older perls'

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~hppa ~ppc ~ppc64 ~sparc ~x86 ~ppc-aix ~x86-fbsd ~x86-solaris"
IUSE=""

RDEPEND="
	>=dev-perl/Sub-Exporter-Progressive-0.1.11
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
