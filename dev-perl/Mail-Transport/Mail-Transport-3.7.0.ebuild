# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MARKOV
DIST_VERSION=3.007
inherit perl-module

DESCRIPTION="Base class for Email Message Exchange"
SLOT="0"
KEYWORDS="~alpha ~amd64 arm arm64 ~ppc64 ~riscv x86"

RDEPEND="
	>=dev-perl/Mail-Message-3
	!!<dev-perl/Mail-Box-3
"
BDEPEND="${RDEPEND}"
