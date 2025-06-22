# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TOBYINK
DIST_VERSION=0.002
inherit perl-module

DESCRIPTION="Provides a 'Self' type constraint, referring to the caller class or role"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Type-Tiny
	dev-perl/Role-Hooks
"
BDEPEND="
	${RDEPEND}
	test? (
		dev-perl/Role-Tiny
	)
"
