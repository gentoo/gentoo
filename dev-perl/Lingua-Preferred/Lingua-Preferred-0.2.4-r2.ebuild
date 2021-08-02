# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DIST_AUTHOR=EDAVIS
inherit perl-module

DESCRIPTION="Pick a language based on user's preferences"

SLOT="0"
LICENSE="|| ( Artistic GPL-2+ )"
KEYWORDS="amd64 ~arm arm64 ppc x86 ~amd64-linux ~x86-linux"

RDEPEND="dev-perl/Log-TraceMessages"
BDEPEND="${RDEPEND}"
