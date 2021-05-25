# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=MSCHWERN
DIST_VERSION=0.02
inherit perl-module

DESCRIPTION="test code which forks"

SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~hppa ~mips ~sparc"
IUSE="test"
RESTRICT="!test? ( test )"
