# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/DateTime-Format-SQLite/DateTime-Format-SQLite-0.110.0.ebuild,v 1.2 2014/10/12 15:43:13 zlogene Exp $

EAPI=5

MODULE_AUTHOR=CFAERBER
MODULE_VERSION=0.11
inherit perl-module

DESCRIPTION="Parse and format SQLite dates and times"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-solaris"
IUSE=""

RDEPEND=">=dev-perl/DateTime-0.51
	>=dev-perl/DateTime-Format-Builder-0.79.01"
DEPEND="${RDEPEND}"

SRC_TEST=do
