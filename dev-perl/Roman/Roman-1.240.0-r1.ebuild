# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CHORNY
DIST_VERSION=1.24
DIST_A_EXT=tar.gz

inherit perl-module

DESCRIPTION="Perl module for conversion between Roman and Arabic numerals"

SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~mips ~s390 x86 ~amd64-linux ~x86-linux"

DEPEND="test? (
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"
