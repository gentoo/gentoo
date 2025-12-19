# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EBO_DESCRIPTION="Clustal Omega - Multiple Sequence Alignment"

inherit autotools emboss-r3

KEYWORDS="~amd64 ~x86"

RDEPEND="sci-biology/clustal-omega"

S="${WORKDIR}/CLUSTALOMEGA-1.1.0"
PATCHES=( "${FILESDIR}"/${PN}-1.1.0_fix-build-system.patch )

src_prepare() {
	default
	eautoreconf
}
