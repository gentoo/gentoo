# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit check-reqs cmake

DESCRIPTION="Electronic Schematic and PCB design tools 3D package libraries"
HOMEPAGE="https://gitlab.com/kicad/libraries/kicad-packages3D"

if [[ ${PV} == 9999 ]]; then
	EGIT_REPO_URI="https://gitlab.com/kicad/libraries/kicad-packages3D.git"
	inherit git-r3
else
	SRC_URI="https://gitlab.com/kicad/libraries/kicad-packages3D/-/archive/${PV}/kicad-packages3D-${PV}.tar.bz2 -> ${P}.tar.bz2"
	S="${WORKDIR}/${PN/3d/3D}-${PV}"

	KEYWORDS="~amd64 ~arm64 ~riscv ~x86"
fi

LICENSE="CC-BY-SA-4.0"
SLOT="0"
IUSE="stpz"

RDEPEND=">=sci-electronics/kicad-10.0.0
	stpz? ( ~sci-electronics/kicad-footprints-${PV}[stpz] )"

if [[ ${PV} == 9999 ]] ; then
	# x11-misc-util/macros only required on live ebuilds
	BDEPEND=">=x11-misc/util-macros-1.18"
fi

CHECKREQS_DISK_BUILD="11G"

src_install() {
	cmake_src_install

	if use stpz; then
		# Bug 935664.
		einfo "Compressing .step models to .stpz ..."
		local f
		while IFS= read -r -d '' f; do
			gzip -n "${f}" || die "gzip ${f} failed"
			mv "${f}.gz" "${f%.step}.stpz" || die "rename ${f}.gz failed"
		done < <(find "${ED}" -type f -name '*.step' -print0)
	fi
}

pkg_postinst() {
	if use stpz; then
		elog "3D models installed as .stpz (gzip-compressed STEP)."
		elog "Projects authored on this system reference .stpz paths"
		elog "and 3D viewers on systems with plain .step libraries"
		elog "will not find the models. Disable USE=stpz if you share"
		elog "projects across distributions."
	fi
}
