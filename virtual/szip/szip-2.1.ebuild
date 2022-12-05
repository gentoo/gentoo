# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Virtual for szip compression drop-in replacements"
SLOT="0/2"
KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~loong ppc ppc64 ~riscv sparc x86 ~amd64-linux ~x86-linux"

RDEPEND="|| (
	sci-libs/libaec[szip]
	sci-libs/szip )"
