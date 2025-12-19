# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

EBO_DESCRIPTION="HMMER wrapper - sequence analysis with profile HMMs"

inherit autotools emboss-r3

KEYWORDS="~amd64 ~x86"

RDEPEND="sci-biology/hmmer:2"

S="${WORKDIR}/HMMER-2.3.2.650"
PATCHES=(
	"${FILESDIR}"/${PN}-2.3.2.650_fix-build-system.patch
	# sci-biology/hmmer:2 has renamed commandline program names
	"${FILESDIR}"/${PN}-2.3.2.660-slotted-hmmer2.patch
)

src_prepare() {
	default
	eautoreconf
}
