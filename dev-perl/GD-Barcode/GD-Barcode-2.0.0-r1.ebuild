# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MICHIELB
DIST_VERSION=2.00
inherit perl-module

DESCRIPTION="Create barcode images with GD"

SLOT="0"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~ia64 ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	virtual/perl-Exporter
	dev-perl/GD
	virtual/perl-parent

"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=virtual/perl-Test2-Suite-0.0.60
	)
"
