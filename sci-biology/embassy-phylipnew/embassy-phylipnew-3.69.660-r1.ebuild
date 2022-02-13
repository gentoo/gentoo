# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EBO_DESCRIPTION="The Phylogeny Inference Package"

inherit autotools emboss-r3

LICENSE+=" free-noncomm"

KEYWORDS="~amd64 ~x86 ~x86-linux"

S="${WORKDIR}/PHYLIPNEW-3.69.650"
PATCHES=(
	"${FILESDIR}"/${PN}-3.69.650_fix-build-system.patch
	"${FILESDIR}"/${PN}-3.69.650-fno-common.patch
)

src_prepare() {
	default
	eautoreconf
}
