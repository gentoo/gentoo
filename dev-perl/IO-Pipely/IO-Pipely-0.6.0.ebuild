# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=RCAPUTO
DIST_VERSION=0.006
inherit perl-module

DESCRIPTION="Portably create pipe() or pipe-like handles, one way or another"

SLOT="0"
KEYWORDS="~amd64 ~ppc x86"

RDEPEND="
	>=virtual/perl-Exporter-5.720.0
	>=virtual/perl-IO-1.380.0
"
BDEPEND="
	${RDEPEND}
	test? (
		>=virtual/perl-Carp-1.420.0
		>=virtual/perl-Scalar-List-Utils-1.460.0
	)
"
