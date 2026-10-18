# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cmake

DESCRIPTION="Electronic Schematic and PCB design tools footprint libraries"
HOMEPAGE="https://gitlab.com/kicad/libraries/kicad-footprints"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.com/kicad/libraries/kicad-footprints.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.com/kicad/libraries/${PN}/-/archive/${PV}/${P}.tar.bz2"

	KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
fi

LICENSE="CC-BY-SA-4.0"
SLOT="0"
IUSE="stpz"

RDEPEND=">=sci-electronics/kicad-8.0.0
	stpz? ( ~sci-electronics/kicad-packages3d-${PV}[stpz] )"

if [[ ${PV} == 9999 ]] ; then
#	 x11-misc-util/macros only required on live ebuilds
	BDEPEND+=" >=x11-misc/util-macros-1.18"
fi

src_install() {
	cmake_src_install

	if use stpz; then
		# Bug 935664. Match only quoted model paths to avoid
		# touching unrelated text.
		einfo "Rewriting .kicad_mod model refs from .step to .stpz ..."
		find "${ED}" -type f -name '*.kicad_mod' -print0 \
			| xargs -0 sed -i 's|\.step"|.stpz"|g' \
			|| die "model ref rewrite failed"
	fi
}

pkg_postinst() {
	if use stpz; then
		elog "Footprint .kicad_mod model refs rewritten to .stpz."
		elog "Projects edited on this system depend on the matching"
		elog "kicad-packages3d[stpz] install. Other distros ship"
		elog "uncompressed .step models; disable USE=stpz if you"
		elog "share projects with users on those systems."
	fi
}
