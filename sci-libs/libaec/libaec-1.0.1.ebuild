# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils vcs-snapshot

DESCRIPTION="Adaptive Entropy Coding library"
HOMEPAGE="https://gitlab.dkrz.de/k202009/libaec"
SRC_URI="${HOMEPAGE}/repository/archive.tar.gz?ref=v${PV} -> ${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/2"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="+szip"

DEPEND=""
RDEPEND="szip? ( !sci-libs/szip )"

src_install() {
	cmake-utils_src_install
	# avoid conflict with szip (easier than to patch autotools)
	if ! use szip; then
		rm "${ED}"/usr/include/szlib.h || die
		rm "${ED}"/usr/$(get_libdir)/libsz* || die
		rm "${ED}"/usr/share/doc/${PF}/README.SZIP || die
	fi
}
