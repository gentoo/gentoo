# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=FRODWITH
MODULE_VERSION=0.02
inherit perl-module

DESCRIPTION="Attributes with aliases for constructor arguments"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="
	dev-perl/Moose
"
DEPEND="${DEPEND}
	>=dev-perl/Module-Build-Tiny-0.23.0
	test? (
		dev-perl/Test-Pod
		virtual/perl-Test-Simple
	)
"

SRC_TEST="do"
mytargets=install
