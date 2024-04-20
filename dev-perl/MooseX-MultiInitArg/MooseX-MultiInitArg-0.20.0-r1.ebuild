# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=FRODWITH
DIST_VERSION=0.02
inherit perl-module

DESCRIPTION="Attributes with aliases for constructor arguments"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x64-macos"

RDEPEND="
	dev-perl/Moose
"
BDEPEND="${DEPEND}
	>=dev-perl/Module-Build-Tiny-0.23.0
	test? (
		dev-perl/Test-Pod
		virtual/perl-Test-Simple
	)
"

mytargets=install
