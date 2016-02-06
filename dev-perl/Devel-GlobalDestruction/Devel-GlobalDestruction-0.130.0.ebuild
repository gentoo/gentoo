# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=HAARG
MODULE_VERSION=0.12
inherit perl-module

DESCRIPTION='Provides function returning the equivalent of ${^GLOBAL_PHASE} eq DESTRUCT for older perls'

SLOT="0"
KEYWORDS="amd64 ~arm hppa ~ppc ~ppc64 ~x86 ~ppc-aix ~x86-fbsd ~x86-solaris"
IUSE=""

RDEPEND="
	>=dev-perl/Sub-Exporter-Progressive-0.1.11
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-CBuilder-0.270.0
	virtual/perl-ExtUtils-MakeMaker
"

SRC_TEST="do parallel"
