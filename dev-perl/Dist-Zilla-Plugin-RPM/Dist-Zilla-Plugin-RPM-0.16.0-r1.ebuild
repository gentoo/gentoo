# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SKYSYMBOL
DIST_VERSION=0.016
inherit perl-module

DESCRIPTION="Build an RPM from your Dist::Zilla release"

SLOT="0"
KEYWORDS="amd64 ~x86"

RDEPEND="
	dev-perl/Dist-Zilla
	dev-perl/IPC-Run
	dev-perl/Moose
	dev-perl/Moose-Autobox
	dev-perl/Path-Class
	dev-perl/Path-Tiny
	dev-perl/Text-Template
	dev-perl/namespace-autoclean
	app-arch/rpm
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/File-Which
		dev-perl/Test-Differences
		>=virtual/perl-Test-Simple-0.880.0
	)
"
