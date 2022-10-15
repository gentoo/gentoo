# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="DMUEY"
DIST_VERSION="0.6"

inherit perl-module

DESCRIPTION="Check @INC once for modules that you want but may not have"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-perl/File-Path-Tiny"

BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( dev-perl/Test-Carp )"
