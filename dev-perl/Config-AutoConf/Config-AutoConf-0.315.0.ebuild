# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR="REHSACK"
DIST_VERSION=${PV%.0}

inherit perl-module

DESCRIPTION="A module to implement some of AutoConf macros in pure perl"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 x86"
IUSE="test"

RDEPEND="
	dev-perl/Capture-Tiny
	virtual/perl-Carp
	virtual/perl-Exporter
	>=virtual/perl-ExtUtils-CBuilder-0.280.220
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	>=virtual/perl-Scalar-List-Utils-1.180.0
	virtual/perl-Text-ParseWords
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? ( >=virtual/perl-Test-Simple-0.900.0 )
"
