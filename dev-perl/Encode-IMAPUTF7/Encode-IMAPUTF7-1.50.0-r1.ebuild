# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=PMAKHOLM
MODULE_VERSION=1.05
inherit perl-module

DESCRIPTION="Modification of UTF-7 encoding for IMAP"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="virtual/perl-Encode"
DEPEND="${RDEPEND}
	test? ( dev-perl/Test-NoWarnings )"

SRC_TEST="do"
