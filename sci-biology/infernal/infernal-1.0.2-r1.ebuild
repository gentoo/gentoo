# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit toolchain-funcs

DESCRIPTION="Inference of RNA alignments"
HOMEPAGE="http://infernal.janelia.org/"
SRC_URI="ftp://selab.janelia.org/pub/software/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="mpi"

RDEPEND="mpi? ( virtual/mpi )"
DEPEND="${RDEPEND}"

PATCHES=(
	"${FILESDIR}"/${P}-fix-build-system.patch
	"${FILESDIR}"/${P}-overflows.patch
	"${FILESDIR}"/${P}-perl-5.16-2.patch
)

src_configure() {
	tc-export AR
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
