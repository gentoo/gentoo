# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=KAZUHO
DIST_VERSION=0.35
inherit perl-module

DESCRIPTION="A superdaemon for hot-deploying server programs"

SLOT="0"
KEYWORDS="amd64 ~riscv ~x86"

RDEPEND="
"
BDEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.400.500
	test? (
		virtual/perl-IO-Socket-IP
		dev-perl/Test-Requires
		dev-perl/Test-SharedFork
		>=dev-perl/Test-TCP-2.80.0
	)
"

DIST_TEST=do
