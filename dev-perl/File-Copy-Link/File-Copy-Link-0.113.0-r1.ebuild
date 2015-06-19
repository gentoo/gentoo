# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/File-Copy-Link/File-Copy-Link-0.113.0-r1.ebuild,v 1.2 2015/06/13 22:46:22 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=RMBARKER
MODULE_VERSION=0.113
inherit perl-module

DESCRIPTION="Perl extension for replacing a link by a copy of the linked file"

SLOT="0"
KEYWORDS="~amd64"
IUSE=""

RDEPEND="virtual/perl-File-Spec"
DEPEND="dev-perl/Module-Build
	virtual/perl-File-Temp
	${RDEPEND}"

SRC_TEST="do"
