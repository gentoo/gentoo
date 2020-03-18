# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=YVES
MODULE_VERSION=0.02

inherit perl-module

DESCRIPTION="Tied hash with specific methods overriden by callbacks"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="test"
RESTRICT="!test? ( test )"

DEPEND="test? ( dev-perl/Test-Pod )"

SRC_TEST="do parallel"
