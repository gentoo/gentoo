# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=5

MODULE_AUTHOR=EDAVIS
inherit perl-module

DESCRIPTION="Pick a language based on user's preferences"

SLOT="0"
LICENSE="|| ( Artistic GPL-2+ )"
KEYWORDS="amd64 ~arm ppc x86"
IUSE=""

RDEPEND="dev-perl/Log-TraceMessages"
DEPEND="${RDEPEND}"

SRC_TEST="do parallel"
