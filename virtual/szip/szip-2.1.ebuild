# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Virtual for szip compression drop-in replacements"
SLOT="0/2"
KEYWORDS="alpha amd64 ~arm arm64 hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux"

RDEPEND="|| (
	sci-libs/libaec[szip]
	sci-libs/szip )"
