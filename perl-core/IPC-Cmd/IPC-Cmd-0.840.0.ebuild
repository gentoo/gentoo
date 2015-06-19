# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/perl-core/IPC-Cmd/IPC-Cmd-0.840.0.ebuild,v 1.3 2015/06/06 19:36:46 dilfridge Exp $

EAPI=5

MODULE_AUTHOR=BINGOS
MODULE_VERSION=0.84
inherit perl-module

DESCRIPTION="Finding and running system commands made easy"

SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="virtual/perl-Locale-Maketext-Simple
	virtual/perl-Module-Load-Conditional
	>=virtual/perl-Params-Check-0.26"
RDEPEND="${DEPEND}"

SRC_TEST=do
