# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=ETJ
DIST_VERSION=2.101

inherit perl-module

DESCRIPTION="A PDL interface to the Gnu Scientific Library"

SLOT="0"
KEYWORDS="~amd64 ~ppc ~x86"

RDEPEND="
	>=dev-perl/PDL-2.96.0
	sci-libs/gsl
"
BDEPEND="${RDEPEND}
"
