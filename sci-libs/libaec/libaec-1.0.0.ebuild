# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils
# number that might change every version
PID="631e85bcf877c2dcaca9b2e6d6526339"

DESCRIPTION="Adaptive Entropy Coding library"
HOMEPAGE="https://gitlab.dkrz.de/k202009/libaec"
SRC_URI="${HOMEPAGE}/uploads/${PID}/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0/2"
KEYWORDS="~amd64 ~arm64 ~x86 ~amd64-linux ~x86-linux"
IUSE="static-libs +szip"

DEPEND=""
RDEPEND="szip? ( !sci-libs/szip )"

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	# avoid conflict with szip (easier than to patch autotools)
	if ! use szip; then
		rm "${ED}"/usr/include/szlib.h || die
		rm "${ED}"/usr/$(get_libdir)/libsz* || die
		rm "${ED}"/usr/share/doc/${PF}/README.SZIP || die
	fi
	use static-libs || prune_libtool_files --all
}
