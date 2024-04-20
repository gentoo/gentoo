# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=YVES
DIST_VERSION=0.02

inherit perl-module

DESCRIPTION="Tied hash with specific methods overriden by callbacks"

SLOT="0"
KEYWORDS="~amd64 ~x86"

BDEPEND="test? ( dev-perl/Test-Pod )"
