# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=LEONT
MODULE_VERSION=0.64
inherit perl-module

DESCRIPTION="Memory mapping made simple and safe"

SLOT="0"
KEYWORDS="amd64 arm ppc x86 ~amd64-linux ~x86-linux"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	virtual/perl-Carp
	dev-perl/PerlIO-Layers
	>=dev-perl/Sub-Exporter-Progressive-0.1.5
	virtual/perl-XSLoader
"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.360.100
	test? (
		virtual/perl-File-Spec
		virtual/perl-IO
		virtual/perl-Scalar-List-Utils
		dev-perl/Test-Fatal
		virtual/perl-Test-Simple
		>=dev-perl/Test-Warnings-0.5.0
		virtual/perl-Time-HiRes
	)
"

SRC_TEST="do parallel"
