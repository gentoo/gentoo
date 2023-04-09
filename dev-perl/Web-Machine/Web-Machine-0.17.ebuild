# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.17
inherit perl-module

DESCRIPTION="A Perl port of Webmachine"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	virtual/perl-Carp
	virtual/perl-Data-Dumper
	virtual/perl-Encode
	dev-perl/HTTP-Headers-ActionPack
	dev-perl/Hash-MultiValue
	dev-perl/IO-Handle-Util
	virtual/perl-Scalar-List-Utils
	virtual/perl-Locale-Maketext
	dev-perl/Module-Runtime
	dev-perl/Sub-Exporter
	dev-perl/Try-Tiny
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	virtual/perl-ExtUtils-MakeMaker
"
