# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5
MODULE_AUTHOR=ISHIGAKI
MODULE_VERSION=0.17
inherit perl-module

DESCRIPTION='do use_ok() for all the MANIFESTed modules'

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	virtual/perl-Exporter
	virtual/perl-ExtUtils-Manifest
	>=virtual/perl-Test-Simple-0.600.0
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
"
