# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils
# number that might change every version
PID=453

DESCRIPTION="Adaptive Entropy Coding library"
HOMEPAGE="https://www.dkrz.de/redmine/projects/aec"
SRC_URI="https://www.dkrz.de/redmine/attachments/download/${PID}/${P}.tar.gz"

LICENSE="LIBAEC"
SLOT="0/2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
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
