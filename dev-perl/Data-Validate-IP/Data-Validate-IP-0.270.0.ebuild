# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.27
DIST_EXAMPLES=("bench/*")

inherit perl-module

DESCRIPTION="Lightweight IPv4 and IPv6 validation module"

SLOT="0"
KEYWORDS="amd64 hppa sparc x86"
IUSE="test"

RDEPEND="
	virtual/perl-Exporter
	>=dev-perl/NetAddr-IP-4
	virtual/perl-Scalar-List-Utils
"
DEPEND="${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/Test-Requires
	)
"
