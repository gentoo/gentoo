# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SALVA
DIST_VERSION=1.93
DIST_EXAMPLES=("samples/*")
inherit perl-module

DESCRIPTION="SSH File Transfer Protocol client"

SLOT="0"
KEYWORDS="amd64 ~hppa ~sparc x86"
IUSE="examples"

RDEPEND="
	virtual/perl-Scalar-List-Utils
	virtual/perl-Time-HiRes
	virtual/ssh
"
BDEPEND="
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-Test-Simple
	)
"
