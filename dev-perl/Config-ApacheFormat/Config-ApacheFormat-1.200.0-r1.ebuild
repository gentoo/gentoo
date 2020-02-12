# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=SAMTREGAR
MODULE_VERSION=1.2
inherit perl-module

DESCRIPTION="use Apache format config files"

SLOT="0"
KEYWORDS="~alpha amd64 ia64 ~ppc sparc x86"
IUSE=""

RDEPEND="dev-perl/Class-MethodMaker
		virtual/perl-Text-Balanced
		virtual/perl-File-Spec"
DEPEND="${RDEPEND}"

SRC_TEST="do"
