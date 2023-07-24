# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.31
DIST_EXAMPLES=("bench/*")

inherit perl-module

DESCRIPTION="IPv4 and IPv6 validation methods"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ppc64 ~riscv ~sparc ~x86"

RDEPEND="
	virtual/perl-Exporter
	>=dev-perl/NetAddr-IP-4
	virtual/perl-Scalar-List-Utils
"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		virtual/perl-File-Spec
		>=virtual/perl-Test-Simple-0.960.0
		dev-perl/Test-Requires
	)
"
