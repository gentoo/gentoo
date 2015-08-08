# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=HAARG
MODULE_VERSION=0.12
inherit perl-module

DESCRIPTION="Expose PL_dirty, the flag which marks global destruction"

SLOT="0"
KEYWORDS="amd64 ~arm ~hppa ppc ~ppc64 x86 ~ppc-aix ~x86-fbsd ~x86-solaris"
IUSE=""

RDEPEND=">=dev-perl/Sub-Exporter-Progressive-0.1.11"
DEPEND="
	>=virtual/perl-ExtUtils-CBuilder-0.27.0
	${RDEPEND}
"

SRC_TEST="do parallel"
