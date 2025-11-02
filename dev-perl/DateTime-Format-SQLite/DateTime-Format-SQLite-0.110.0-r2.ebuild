# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DIST_AUTHOR=CFAERBER
DIST_VERSION=0.11
inherit perl-module

DESCRIPTION="Parse and format SQLite dates and times"

SLOT="0"
KEYWORDS="amd64 arm arm64 ~ppc ~riscv x86"

RDEPEND="
	>=dev-perl/DateTime-0.51
	>=dev-perl/DateTime-Format-Builder-0.79.01
"
BDEPEND="${RDEPEND}
	test? (
		dev-perl/DBD-SQLite
	)
"

PERL_RM_FILES=(
	t/10pod.t
	t/11pod_cover.t
)
