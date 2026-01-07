# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EBO_DESCRIPTION="Vienna RNA package - RNA folding"

inherit autotools emboss-r3

KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/VIENNA-1.7.2.650"
PATCHES=(
	"${FILESDIR}"/${PN}-1.7.2.650_fix-build-system.patch
	"${FILESDIR}"/${PN}-1.7.2.650-C99-inline.patch
)

src_prepare() {
	default
	eautoreconf
}
