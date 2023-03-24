# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="PREACTION"
DIST_VERSION="1.007"

inherit perl-module

DESCRIPTION="Role for event emitting classes"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-perl/Moo
	dev-perl/Module-Runtime"

BDEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Lib
		dev-perl/Test-Fatal
		dev-perl/Test-API
	)"
