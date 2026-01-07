# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EBO_DESCRIPTION="sim4 - Alignment of cDNA and genomic DNA"

inherit autotools emboss-r3 flag-o-matic

KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/ESIM4-1.0.0.650"
PATCHES=( "${FILESDIR}"/${PN}-1.0.0.650_fix-build-system.patch )

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/862258
	#
	# Upstream is dead since 2013.
	filter-lto

	emboss-r3_src_configure
}
