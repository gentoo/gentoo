# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EBO_DESCRIPTION="The Phylogeny Inference Package"

inherit autotools emboss-r3 flag-o-matic

LICENSE+=" free-noncomm"

KEYWORDS="~amd64 ~x86"

S="${WORKDIR}/PHYLIPNEW-3.69.650"
PATCHES=(
	"${FILESDIR}"/${PN}-3.69.650_fix-build-system.patch
	"${FILESDIR}"/${PN}-3.69.650-fno-common.patch
)

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	# -Werror=lto-type-mismatch
	# https://bugs.gentoo.org/862261
	#
	# Upstream is dead since 2013.
	filter-lto

	emboss-r3_src_configure
}
