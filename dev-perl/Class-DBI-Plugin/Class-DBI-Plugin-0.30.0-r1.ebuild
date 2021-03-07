# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=JCZEUS
DIST_VERSION=0.03
inherit perl-module

DESCRIPTION="Abstract base class for Class::DBI plugins"

SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-solaris"

RDEPEND="
	>=dev-perl/Class-DBI-0.900.0
"
BDEPEND="${RDEPEND}"
