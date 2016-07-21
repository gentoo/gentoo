# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=GAAS
MODULE_VERSION=1.06
inherit perl-module

DESCRIPTION="Dump arbitrary data structures as XML"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86 ~sparc-solaris"
IUSE=""

RDEPEND=">=virtual/perl-MIME-Base64-2
	>=dev-perl/XML-Parser-2
	>=dev-perl/Array-RefElem-0.01"
DEPEND="${RDEPEND}"

SRC_TEST="do"
