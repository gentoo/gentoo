# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=NEILB
DIST_VERSION=2.01
inherit perl-module

DESCRIPTION="POD Object Model"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="virtual/perl-parent"
BDEPEND="
	test? (
		>=dev-perl/YAML-0.67
		dev-perl/File-Slurper
		dev-perl/Test-Differences
	)"
