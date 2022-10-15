# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="DMUEY"
DIST_VERSION="0.2"

inherit perl-module

DESCRIPTION="test your code for calls to Carp functions"

SLOT="0"
KEYWORDS="~amd64"

BDEPEND="dev-perl/Module-Build"
