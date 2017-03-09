# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Inference of RNA alignments"
HOMEPAGE="http://infernal.janelia.org/"
SRC_URI="ftp://selab.janelia.org/pub/software/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
IUSE="mpi"
KEYWORDS="amd64 x86"

RDEPEND="mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-parallel-build.patch
	"${FILESDIR}"/${P}-overflows.patch
	"${FILESDIR}"/${P}-perl-5.16-2.patch
	"${FILESDIR}"/${P}-ldflags.patch
	"${FILESDIR}"/${P}-respect-DESTDIR.patch
)

src_configure() {
	econf $(use_enable mpi)
}

src_install() {
	DOCS=( 00README* Userguide.pdf documentation/release-notes )
	default

	pushd documentation/manpages >/dev/null || die
	local i
	for i in *.man; do
		newman "${i}" "${i/.man/.1}"
	done
	popd >/dev/null || die

	insinto /usr/share/${PN}
	doins -r benchmarks tutorial intro matrices
}
