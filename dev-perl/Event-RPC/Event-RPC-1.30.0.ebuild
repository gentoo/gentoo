# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=JRED
MODULE_VERSION=1.03
inherit perl-module

DESCRIPTION="Event based transparent Client/Server RPC framework"

SLOT="0"
KEYWORDS="amd64 ia64 ppc ppc64 sparc x86"
IUSE=""

RDEPEND="|| ( dev-perl/Event dev-perl/glib-perl )
	dev-perl/IO-Socket-SSL
	dev-perl/Net-SSLeay
	virtual/perl-Storable"
DEPEND="${RDEPEND}"

SRC_TEST="do"
