# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=TSIBLEY
MODULE_VERSION=0.10
inherit perl-module

DESCRIPTION="Compact many CSS files into one big file"

SLOT="0"
KEYWORDS="amd64 ~ppc ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

RDEPEND="dev-perl/URI
	virtual/perl-File-Spec"
DEPEND="test? ( ${RDEPEND}
		dev-perl/Test-LongString )"

SRC_TEST="do"
