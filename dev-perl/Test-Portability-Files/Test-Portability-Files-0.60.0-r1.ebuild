# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Test-Portability-Files/Test-Portability-Files-0.60.0-r1.ebuild,v 1.1 2014/08/26 17:32:57 axs Exp $

EAPI=5

MODULE_AUTHOR=ABRAXXA
MODULE_VERSION=0.06
inherit perl-module

DESCRIPTION="Check file names portability"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	virtual/perl-File-Spec
	virtual/perl-Test-Simple
"
DEPEND="${RDEPEND}"

SRC_TEST="do"
