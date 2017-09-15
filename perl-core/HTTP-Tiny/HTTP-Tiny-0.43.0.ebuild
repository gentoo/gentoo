# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5
MODULE_AUTHOR=DAGOLDEN
MODULE_VERSION=0.043
inherit perl-module

DESCRIPTION='A small, simple, correct HTTP/1.1 client'
LICENSE=" || ( Artistic GPL-2 )"
SLOT="0"
KEYWORDS=""
IUSE="test"

DEPEND="
	>=virtual/perl-ExtUtils-MakeMaker-6.30
	virtual/perl-IO
	virtual/perl-Time-Local
	test? (
		virtual/perl-Data-Dumper
		virtual/perl-Exporter
		virtual/perl-ExtUtils-MakeMaker
		virtual/perl-File-Spec
		virtual/perl-File-Spec
		virtual/perl-File-Temp
		virtual/perl-IO
		virtual/perl-IPC-Cmd
		virtual/perl-Scalar-List-Utils
		>=virtual/perl-Test-Simple-0.96
	)
"
RDEPEND="
	virtual/perl-IO
	virtual/perl-Time-Local
"
SRC_TEST="do"
