# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DIST_AUTHOR=GRANTM
DIST_VERSION=2.22
inherit perl-module

DESCRIPTION="An API for simple XML files"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~x86 ~amd64-fbsd ~x86-fbsd"
IUSE="test"

RDEPEND="
	virtual/perl-Storable
	>=dev-perl/XML-NamespaceSupport-1.40.0
	>=dev-perl/XML-SAX-0.150.0
	dev-perl/XML-SAX-Expat
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.880.0 )
"
