# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RWSTAUNER
DIST_VERSION=0.105
inherit perl-module

DESCRIPTION="Add '-remove' functionality to a bundle"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Dist-Zilla
	dev-perl/Moose
	>=virtual/perl-Scalar-List-Utils-1.450.0
"
BDEPEND="${RDEPEND}
	test? (
		>=virtual/perl-Test-Simple-0.960.0
	)
"
