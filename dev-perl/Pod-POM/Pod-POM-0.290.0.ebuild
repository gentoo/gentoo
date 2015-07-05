# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Pod-POM/Pod-POM-0.290.0.ebuild,v 1.1 2015/07/05 10:30:59 zlogene Exp $

EAPI=5

MODULE_AUTHOR=ANDREWF
MODULE_VERSION=0.29
inherit perl-module

DESCRIPTION="POD Object Model"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"

RDEPEND="virtual/perl-parent"
DEPEND="
	test? (
		dev-perl/Test-Differences
		>=dev-perl/yaml-0.67
		dev-perl/File-Slurp
	)"

SRC_TEST=do
