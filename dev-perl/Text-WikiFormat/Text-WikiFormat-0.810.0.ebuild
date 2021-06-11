# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=CYCLES
MODULE_VERSION=0.81
inherit perl-module

DESCRIPTION="Translate Wiki formatted text into other formats"

SLOT="0"
KEYWORDS="amd64 ~ppc x86 ~amd64-linux ~x86-linux ~ppc-macos ~sparc-solaris"
IUSE=""

RDEPEND="dev-perl/URI
	virtual/perl-Scalar-List-Utils"
DEPEND="${RDEPEND}
	>=dev-perl/Module-Build-0.28"

SRC_TEST="do"
