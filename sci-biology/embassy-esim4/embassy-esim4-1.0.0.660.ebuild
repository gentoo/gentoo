# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EBO_DESCRIPTION="sim4 - Alignment of cDNA and genomic DNA"

EBO_EAUTORECONF=1

inherit emboss-r2

KEYWORDS="~amd64 ~x86 ~x86-linux"

S="${WORKDIR}/ESIM4-1.0.0.650"
PATCHES=( "${FILESDIR}"/${PN}-1.0.0.650_fix-build-system.patch )
