# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=BHALLISSY
DIST_VERSION=1.06
inherit perl-module

DESCRIPTION="Module for compiling and altering fonts"

LICENSE="Artistic-2 OFL-1.1"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~m68k ~mips ppc ppc64 ~riscv ~s390 ~sparc x86"

RDEPEND="
	dev-perl/IO-String
	dev-perl/XML-Parser
"
BDEPEND="${RDEPEND}"

PERL_RM_FILES=(
	t/changes.t
)
