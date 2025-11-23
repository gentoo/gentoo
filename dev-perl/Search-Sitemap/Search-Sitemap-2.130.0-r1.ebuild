# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=JASONK
DIST_VERSION=2.13
inherit perl-module

DESCRIPTION="Perl extension for managing Search Engine Sitemaps"
SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Module-Find
	dev-perl/Class-Trigger
	dev-perl/MooseX-ClassAttribute
	dev-perl/MooseX-Types
	dev-perl/MooseX-Types-URI
	dev-perl/Moose
"
BDEPEND="${RDEPEND}
	dev-perl/Module-Install
	test? (
		dev-perl/Test-Most
		dev-perl/Test-Mock-LWP
		dev-perl/Test-Mock-LWP-Dispatch
	)
"
