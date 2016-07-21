# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=PETDANCE
MODULE_VERSION=1.12
inherit perl-module

DESCRIPTION="File::Next is an iterator-based module for finding files"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm ~hppa ~ppc x86 ~x86-interix ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~x86-solaris"
IUSE="test"

RDEPEND="virtual/perl-File-Spec
	virtual/perl-Test-Simple"
DEPEND="
	test? ( ${RDEPEND}
		dev-perl/Test-Pod
		dev-perl/Test-Pod-Coverage
	)"

SRC_TEST=do
