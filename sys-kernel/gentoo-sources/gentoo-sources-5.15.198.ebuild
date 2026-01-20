# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI="8"
ETYPE="sources"
K_WANT_GENPATCHES="base extras"
K_GENPATCHES_VER="208"

inherit kernel-2
detect_version
detect_arch

DESCRIPTION="Full sources including the Gentoo patchset for the ${KV_MAJOR}.${KV_MINOR} kernel tree"
HOMEPAGE="https://dev.gentoo.org/~alicef/genpatches"
SRC_URI="${KERNEL_URI} ${GENPATCHES_URI} ${ARCH_URI}"
KEYWORDS="~alpha ~amd64 ~arm ~arm64 ~hppa ~m68k ~mips ~ppc ~ppc64 ~riscv ~s390 ~sparc ~x86"
IUSE="experimental"

pkg_postinst() {
	kernel-2_pkg_postinst
	einfo "For more info on this patchset, and how to report problems, see:"
	einfo "${HOMEPAGE}"
}

pkg_postrm() {
	kernel-2_pkg_postrm
}
