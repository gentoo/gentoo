# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="YAPPO"
DIST_VERSION="0.02"

inherit perl-module

DESCRIPTION="Accept-Language header parser and find available language"

SLOT="0"
KEYWORDS="~amd64"

BDEPEND=">=dev-perl/Module-Build-Tiny-0.39.0
	dev-perl/Module-Build"
