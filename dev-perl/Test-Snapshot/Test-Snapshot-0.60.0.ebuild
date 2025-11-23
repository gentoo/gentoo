# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="ETJ"
DIST_VERSION=0.06

inherit perl-module

DESCRIPTION="Test against data stored in automatically-named file"

LICENSE="|| ( Artistic GPL-1+ )"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Text-Diff
"
DEPEND="${RDEPEND}
	test? ( dev-perl/Capture-Tiny )
"
