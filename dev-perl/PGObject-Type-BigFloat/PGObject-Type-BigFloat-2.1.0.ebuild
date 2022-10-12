# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="EHUELS"
DIST_VERSION="2.001"

inherit perl-module

DESCRIPTION="Math::BigFloat wrappers for PGObject classes"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-perl/PGObject"

BDEPEND="${RDEPEND}"
