# Copyright 2020-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=DROLSKY
DIST_VERSION=0.04
inherit perl-module

DESCRIPTION="Set the distribution version from your main module's $VERSION"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-perl/Dist-Zilla-Role-ModuleMetadata
	dev-perl/Dist-Zilla
	dev-perl/Moose
	dev-perl/namespace-autoclean
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/Path-Tiny
		dev-perl/Test-Deep
		dev-perl/Test-Fatal
		>=virtual/perl-Test-Simple-0.960.0
	)
"
