# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for szip compression drop-in replacements"
SLOT="0/2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~loong ~ppc ppc64 ~riscv ~sparc x86"

RDEPEND="|| (
	sci-libs/libaec[szip]
	sci-libs/szip )"
