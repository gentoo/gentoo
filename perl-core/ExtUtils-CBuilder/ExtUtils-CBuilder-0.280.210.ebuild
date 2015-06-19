# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/ExtUtils-CBuilder/ExtUtils-CBuilder-0.280.210.ebuild,v 1.3 2015/06/04 22:06:06 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=AMBS
MODULE_VERSION=0.280210
MODULE_SECTION="ExtUtils"

inherit perl-module

DESCRIPTION="Compile and link C code for Perl modules"

SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	virtual/perl-File-Spec
	virtual/perl-File-Temp
	virtual/perl-IPC-Cmd
	virtual/perl-Perl-OSType"

DEPEND="${RDEPEND}"

SRC_TEST="do"
