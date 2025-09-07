# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BINGOS
DIST_VERSION=0.50
inherit perl-module

DESCRIPTION="User interfaces via Term::ReadLine made easy"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~ppc x86"

RDEPEND="
	dev-perl/Log-Message-Simple
"
BDEPEND="${RDEPEND}
"
