# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=MDXI
MODULE_VERSION=0.9609
inherit perl-module

DESCRIPTION="Perl UI framework based on the curses library"

SLOT="0"
KEYWORDS="amd64 hppa ppc ppc64 x86"
IUSE="test"

RDEPEND="dev-perl/Curses
	dev-perl/TermReadKey"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Pod
	)"

SRC_TEST="do"
