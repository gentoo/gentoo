# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="PREACTION"
DIST_VERSION="0.09"

inherit perl-module

DESCRIPTION="Log::Any adapter for Log::Log4perl"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND=">=dev-perl/Log-Log4perl-1.540.0
	>=dev-perl/Log-Any-1.710.0"

BDEPEND="${RDEPEND}"
