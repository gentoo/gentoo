# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RRWO
DIST_VERSION=v${PV}
inherit perl-module

DESCRIPTION="HTML color names and equivalent RGB values"

SLOT="0"
KEYWORDS="amd64 x86"

RDEPEND="
	dev-perl/Graphics-ColorNames
"
BDEPEND="${RDEPEND}
	test? (
		virtual/perl-File-Spec
		virtual/perl-Module-Metadata
		virtual/perl-Test-Simple
		dev-perl/Test-Most
		>=dev-perl/Type-Tiny-1.4.0
	)
"
