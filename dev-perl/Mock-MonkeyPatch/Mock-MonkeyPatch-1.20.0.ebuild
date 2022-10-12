# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="JBERGER"
DIST_VERSION="1.02"

inherit perl-module

DESCRIPTION="Monkey patching with test mocking in mind"

SLOT="0"
KEYWORDS="~amd64"

BDEPEND=">=dev-perl/Module-Build-Tiny-0.39.0
	dev-perl/Module-Build"
