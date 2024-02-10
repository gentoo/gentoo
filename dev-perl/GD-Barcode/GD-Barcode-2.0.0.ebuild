# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MICHIELB
DIST_VERSION=2.00
inherit perl-module

DESCRIPTION="Create barcode images with GD"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~ppc ~riscv ~x86"

RDEPEND="
	virtual/perl-Exporter
	dev-perl/GD
	virtual/perl-parent

"
BDEPEND="
	${RDEPEND}
	virtual/perl-ExtUtils-MakeMaker
	test? (
		>=dev-perl/Test2-Suite-0.0.60
	)
"
