# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

MODULE_AUTHOR=JWB
MODULE_VERSION=0.48
inherit perl-module

DESCRIPTION="Unix process table information"

SLOT="0"
KEYWORDS="alpha amd64 hppa ia64 ~mips ppc ppc64 sparc x86"
IUSE=""

SRC_TEST="do"
PATCHES=(
	"${FILESDIR}/amd64_canonicalize_file_name_definition.patch"
	"${FILESDIR}/0.45-pthread.patch"
	"${FILESDIR}/0.45-fix-format-errors.patch"
)
