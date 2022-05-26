# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EBO_DESCRIPTION="sim4 - Alignment of cDNA and genomic DNA"

inherit autotools emboss-r3

KEYWORDS="~amd64 ~x86 ~x86-linux"

S="${WORKDIR}/ESIM4-1.0.0.650"
PATCHES=( "${FILESDIR}"/${PN}-1.0.0.650_fix-build-system.patch )

src_prepare() {
	default
	eautoreconf
}
