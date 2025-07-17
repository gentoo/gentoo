# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=YANICK
inherit perl-module

DESCRIPTION="update the next version, semantic-wise"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/CPAN-Changes-0.200.0
	dev-perl/Dist-Zilla
	dev-perl/List-AllUtils
	dev-perl/Moose
	dev-perl/Perl-Version
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Exception
	)
"
