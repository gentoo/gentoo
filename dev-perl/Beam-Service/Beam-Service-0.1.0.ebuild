# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR="PREACTION"
DIST_VERSION="0.001"

inherit perl-module

DESCRIPTION="Role for services to access Beam::Wire features"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="dev-perl/Type-Tiny
	dev-perl/Moo"

BDEPEND="${RDEPEND}
	test? ( dev-perl/Test-Fatal )"
