# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=PEVANS
DIST_VERSION=0.803
inherit perl-module

DESCRIPTION="Asynchronous event-driven programming"

SLOT="0"
KEYWORDS="~amd64"

RDEPEND="
	dev-perl/Future
	dev-perl/Struct-Dumb
"
BDEPEND="
	dev-perl/Module-Build
	test? (
		virtual/perl-Test2-Suite
		dev-perl/Test-Future-IO-Impl
		dev-perl/Test-Metrics-Any
	)
"
