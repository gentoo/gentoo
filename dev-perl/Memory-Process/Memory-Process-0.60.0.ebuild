# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=SKIM
DIST_VERSION=0.06
inherit perl-module

DESCRIPTION="Perl class to determine actual memory usage"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~arm arm64 ~hppa ~loong ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"

RDEPEND="
	dev-perl/Memory-Usage
	dev-perl/Readonly
"
BDEPEND="
	test? (
		dev-perl/Capture-Tiny
		dev-perl/Test-NoWarnings
	)
"
