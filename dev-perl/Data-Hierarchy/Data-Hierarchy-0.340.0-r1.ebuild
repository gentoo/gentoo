# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=CLKAO
MODULE_VERSION=0.34
inherit perl-module

DESCRIPTION="Data::Hierarchy - Handle data in a hierarchical structure"

SLOT="0"
KEYWORDS="alpha amd64 ia64 ~mips ~ppc sparc x86 ~amd64-linux ~x86-linux ~ppc-macos ~x86-macos ~sparc-solaris"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND=""
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Exception
	)"

SRC_TEST="do"
