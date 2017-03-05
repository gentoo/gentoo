# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EBO_DESCRIPTION="Transmembrane protein display"

EBO_EAUTORECONF=1

inherit emboss-r2

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

S="${WORKDIR}/TOPO-2.0.650"
PATCHES=( "${FILESDIR}"/${PN}-2.0.650_fix-build-system.patch )
