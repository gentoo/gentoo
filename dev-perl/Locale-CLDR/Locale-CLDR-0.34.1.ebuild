# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="STRANGE"
DIST_VERSION="v0.34.1"

inherit perl-module

DESCRIPTION="A Module to create locale objects with localisation data from the CLDR"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-perl/DateTime-Locale
	>=dev-perl/DateTime-1.540.0
	dev-perl/Moo
	>=dev-perl/namespace-autoclean-0.290.0
	dev-perl/Class-Load
	>=dev-perl/MooX-ClassAttribute-0.11.0
	dev-perl/Type-Tiny
	dev-perl/Unicode-Regex-Set
	dev-perl/List-MoreUtils
	app-i18n/unicode-cldr"

BDEPEND="${RDEPEND}
	dev-perl/Module-Build
	test? ( dev-perl/Test-Exception )"
