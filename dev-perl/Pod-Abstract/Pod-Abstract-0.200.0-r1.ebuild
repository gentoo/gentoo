# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=BLILBURNE
MODULE_VERSION=0.20
inherit perl-module

DESCRIPTION="Abstract document tree for Perl POD documents"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-perl/IO-String
	virtual/perl-Scalar-List-Utils
	virtual/perl-File-Temp
"
DEPEND="${RDEPEND}
	test? (
		virtual/perl-Test-Simple
	)
"

SRC_TEST=do
