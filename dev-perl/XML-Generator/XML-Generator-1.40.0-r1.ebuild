# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=BHOLZMAN
MODULE_VERSION=1.04
inherit perl-module

DESCRIPTION="Perl XML::Generator - A module to help in generating XML documents"

SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 s390 sh sparc x86"
IUSE=""

DEPEND="dev-libs/expat"
RDEPEND="${DEPEND}"

SRC_TEST="do"
