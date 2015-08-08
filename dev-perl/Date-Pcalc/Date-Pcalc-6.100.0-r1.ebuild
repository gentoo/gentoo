# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=STBEY
MODULE_VERSION=6.1
inherit perl-module

DESCRIPTION="Gregorian calendar date calculations"

SLOT="0"
KEYWORDS="~alpha amd64 arm64 ~hppa ~ia64 m68k ppc ~ppc64 s390 sh ~sparc x86"
IUSE=""

DEPEND=">=dev-perl/Bit-Vector-7
	>=dev-perl/Carp-Clan-5.3"
RDEPEND="${DEPEND}"

SRC_TEST="do"
mydoc="ToDo"
PATCHES=( "${FILESDIR}"/6.100.0_identifier_before_numeric_constant.patch )
