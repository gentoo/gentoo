# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Set-Crontab/Set-Crontab-1.30.0.ebuild,v 1.2 2014/10/05 11:44:04 zlogene Exp $

EAPI=5

MODULE_AUTHOR="AMS"
MODULE_VERSION="1.03"

inherit perl-module

DESCRIPTION="Expand crontab(5)-style integer lists"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND=""
DEPEND="virtual/perl-ExtUtils-MakeMaker"

SRC_TEST="do"
