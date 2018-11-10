# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=NEILB
MODULE_VERSION=2.01
inherit perl-module

DESCRIPTION="POD Object Model"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="virtual/perl-parent"
DEPEND="
	test? (
		>=dev-perl/YAML-0.67
		dev-perl/File-Slurper
		dev-perl/Test-Differences
	)"

SRC_TEST=do
