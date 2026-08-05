# Copyright 2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=LEONT
DIST_VERSION=0.020
inherit perl-module

DESCRIPTION="An abstract representation of build processes"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/ExtUtils-Config
	dev-perl/ExtUtils-Helpers
"
BDEPEND="${RDEPEND}"
