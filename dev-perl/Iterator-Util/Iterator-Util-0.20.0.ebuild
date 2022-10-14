# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="ROODE"
DIST_VERSION="0.02"

inherit perl-module

DESCRIPTION="Essential utilities for the Iterator class."

SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-perl/Iterator-0.30.0"

BDEPEND="${RDEPEND}
	test? ( >=dev-perl/Exception-Class-1.450.0 )"
