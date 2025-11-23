# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=MARKOV
DIST_VERSION=1.08
inherit perl-module

DESCRIPTION="Lightweight implementation logger for Log::Report"

SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	>=dev-perl/String-Print-0.910.0
"
BDEPEND="${RDEPEND}"
