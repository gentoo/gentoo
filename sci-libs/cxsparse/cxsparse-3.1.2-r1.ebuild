# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit multilib-minimal

DESCRIPTION="Extended sparse matrix package"
HOMEPAGE="http://www.cise.ufl.edu/research/sparse/CXSparse/"
SRC_URI="https://dev.gentoo.org/~bicatali/distfiles/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="amd64 ~arm hppa ppc ppc64 sparc x86 ~x86-fbsd ~amd64-linux ~x86-linux ~x86-macos"
IUSE="static-libs"

RDEPEND="sci-libs/suitesparseconfig[${MULTILIB_USEDEP}]"
DEPEND="${RDEPEND}
	virtual/pkgconfig"

multilib_src_configure() {
	ECONF_SOURCE="${S}" econf \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	einstalldocs

	# package provides .pc files
	find "${D}" -name '*.la' -delete || die
}
