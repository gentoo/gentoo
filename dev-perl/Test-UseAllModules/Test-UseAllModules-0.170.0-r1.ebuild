# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
DIST_AUTHOR=ISHIGAKI
DIST_VERSION=0.17
inherit perl-module

DESCRIPTION="do use_ok() for all the MANIFESTed modules"

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
PERL_RM_FILES=( "t/99_podcoverage.t" "t/99_pod.t" )
