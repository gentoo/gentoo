# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EBO_DESCRIPTION="InterProScan motif detection add-on package"

EBO_EAUTORECONF=1

inherit emboss-r2

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

S="${WORKDIR}/IPRSCAN-4.3.1.650"
PATCHES=( "${FILESDIR}"/${PN}-4.3.1.650_fix-build-system.patch )
