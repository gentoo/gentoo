# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DAGOLDEN
DIST_VERSION=0.005
inherit perl-module

DESCRIPTION="Minimalist PBKDF2 (RFC 2898) with HMAC-SHA1 or HMAC-SHA2"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"
LICENSE="Apache-2.0"

RDEPEND="
	virtual/perl-Carp
	>=virtual/perl-Exporter-5.570.0
"
DEPEND="${RDEPEND}
	>=virtual/perl-ExtUtils-MakeMaker-6.170.0
	virtual/perl-File-Spec
	virtual/perl-Text-ParseWords
	test? (
		virtual/perl-Encode
		>=virtual/perl-Test-Simple-0.880.0
	)
"
