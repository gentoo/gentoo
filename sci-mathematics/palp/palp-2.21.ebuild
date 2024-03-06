# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit toolchain-funcs

# The arXiv version of the PDF manual
MANUAL_PV=v1

DESCRIPTION="A Package for Analyzing Lattice Polytopes (PALP)"
HOMEPAGE="http://hep.itp.tuwien.ac.at/~kreuzer/CY/CYpalp.html
	https://gitlab.com/stringstuwien/PALP"
SRC_URI="https://gitlab.com/stringstuwien/PALP/-/archive/v${PV}/PALP-v${PV}.tar.bz2
	https://arxiv.org/pdf/1205.4147${MANUAL_PV}.pdf -> ${PN}-manual-${MANUAL_PV}.pdf"
S="${WORKDIR}/PALP-v${PV}"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

# The "mori.x" program pipes input to "Singular".
RDEPEND="sci-mathematics/singular"

src_compile() {
	# Build the additional foo-Nd.x (for N=4,5,6,11) programs needed by
	# SageMath.
	emake CC=$(tc-getCC) all-dims
}

src_install() {
	einstalldocs
	newdoc "${DISTDIR}/${PN}-manual-${MANUAL_PV}.pdf" "manual-${MANUAL_PV}.pdf"

	local PROGS=( class cws mori nef poly )
	local DIMS=( 4 5 6 11 )
	for prog in "${PROGS[@]}"; do
		for N in "${DIMS[@]}"; do
			dobin "${prog}-${N}d.x"
		done
		# The default "make" builds only one variant of each program,
		# foo.x, corresponding to foo-6d.x. Users will expect those
		# names, so we create a symlink from them to foo-6d.x.
		dosym "${prog}-6d.x" "/usr/bin/${prog}.x"
	done
}
