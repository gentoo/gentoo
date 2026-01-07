# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EBO_DESCRIPTION="Transmembrane protein display"

inherit autotools emboss-r3

KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/TOPO-2.0.650"
PATCHES=( "${FILESDIR}"/${PN}-2.0.650_fix-build-system.patch )

src_prepare() {
	default
	eautoreconf
}
