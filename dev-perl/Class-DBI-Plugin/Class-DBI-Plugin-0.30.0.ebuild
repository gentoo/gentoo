# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

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
