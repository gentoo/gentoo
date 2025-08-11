# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BPS
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="Perl module for concise attribute rewriting"

SLOT="0"
KEYWORDS="~amd64 ~riscv ~x86"

RDEPEND="
	dev-perl/URI
	dev-perl/HTML-Tagset
	dev-perl/HTML-Parser
"
BDEPEND="${RDEPEND}"
