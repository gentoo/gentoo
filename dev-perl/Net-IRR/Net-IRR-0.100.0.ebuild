# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=TCAINE
DIST_VERSION=0.10
inherit perl-module

DESCRIPTION="Internet Route Registry daemon (IRRd) client"

SLOT="0"
KEYWORDS="~amd64 ~x86"
RESTRICT="test"
# The only tests are networked
PROPERTIES="test_network"
