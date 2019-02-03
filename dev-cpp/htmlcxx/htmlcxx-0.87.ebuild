# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib-minimal

DESCRIPTION="A simple non-validating CSS 1 and HTML parser for C++"
HOMEPAGE="http://htmlcxx.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"
LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

ECONF_SOURCE="${S}"

multilib_src_configure() {
	econf \
		--enable-shared \
		$(use_enable static-libs static)
}

multilib_src_install_all() {
	# libtool archives covered by pkg-config.
	find "${D}" -name "*.la" -delete || die

	einstalldocs
}
