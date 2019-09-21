# Copyright 1999-2018 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=ROKR
MODULE_VERSION=0.021
inherit perl-module

DESCRIPTION="An easy-to-use and comprehensive named-color library"

SLOT="0"
KEYWORDS="amd64 x86 ~ppc-aix ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos ~m68k-mint ~sparc-solaris ~sparc64-solaris ~x64-solaris ~x86-solaris"
IUSE="test"

RDEPEND="
	dev-perl/Module-Pluggable
	dev-perl/Class-Accessor
	dev-perl/Class-Data-Inheritable
"
DEPEND="${RDEPEND}
	test? (
		dev-perl/Test-Most
	)
"

SRC_TEST="do"
