# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=RCLAMP
MODULE_VERSION=0.33
inherit perl-module

DESCRIPTION="Alternative interface to File::Find"

SLOT="0"
KEYWORDS="~alpha amd64 ~arm hppa ~ia64 ~mips ppc ppc64 ~sparc x86 ~ppc-aix ~x86-fbsd ~amd64-linux ~x86-linux ~ppc-macos ~x64-macos ~x86-macos"
IUSE="test"

RDEPEND="virtual/perl-File-Spec
	>=dev-perl/Number-Compare-0.20.0
	dev-perl/Text-Glob"
DEPEND="${RDEPEND}
	test? ( virtual/perl-Test-Simple )"

SRC_TEST="do"
