# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EBO_DESCRIPTION="The Phylogeny Inference Package"

EBO_EAUTORECONF=1

inherit emboss-r2

LICENSE+=" freedist"

KEYWORDS="~amd64 ~x86 ~x86-linux"

S="${WORKDIR}/PHYLIPNEW-3.69.650"
PATCHES=( "${FILESDIR}"/${PN}-3.69.650_fix-build-system.patch )
