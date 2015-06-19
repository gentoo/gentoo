# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-perl/Class-DBI-Plugin/Class-DBI-Plugin-0.30.0.ebuild,v 1.2 2014/10/19 08:37:46 zlogene Exp $

EAPI=5

MODULE_AUTHOR=JCZEUS
MODULE_VERSION=0.03
inherit perl-module

DESCRIPTION="Abstract base class for Class::DBI plugins"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-solaris"
IUSE=""

RDEPEND="dev-perl/Class-DBI"
DEPEND="${RDEPEND}"

SRC_TEST=do
