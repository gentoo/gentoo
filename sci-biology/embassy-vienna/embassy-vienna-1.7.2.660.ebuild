# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

EBO_DESCRIPTION="Vienna RNA package - RNA folding"

EBO_EAUTORECONF=1

inherit emboss-r2 flag-o-matic

KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"

S="${WORKDIR}/VIENNA-1.7.2.650"
PATCHES=( "${FILESDIR}"/${PN}-1.7.2.650_fix-build-system.patch )

src_configure() {
	append-cflags -std=gnu89
	emboss-r2_src_configure
}
