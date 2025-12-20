# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EBO_DESCRIPTION="InterProScan motif detection add-on package"

inherit autotools emboss-r3

KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/IPRSCAN-4.3.1.650"
PATCHES=( "${FILESDIR}"/${PN}-4.3.1.650_fix-build-system.patch )

src_prepare() {
	default
	eautoreconf
}
