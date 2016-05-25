# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=CHORNY
MODULE_VERSION=1.24
MODULE_A_EXT=tar.gz

inherit perl-module

DESCRIPTION="Perl module for conversion between Roman and Arabic numerals"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~mips ~s390 x86 ~amd64-linux ~x86-linux"
IUSE="test"

DEPEND="test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"

SRC_TEST="do parallel"
