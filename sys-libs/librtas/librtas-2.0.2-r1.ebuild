# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit autotools

DESCRIPTION="A set of libraries for userspace access to RTAS on the PowerPC platform(s)"
HOMEPAGE="https://github.com/ibm-power-utilities/librtas"
SRC_URI="https://github.com/ibm-power-utilities/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1+"
SLOT="0"
KEYWORDS="ppc ppc64 ~ppc64-linux"
IUSE="static-libs"

src_prepare() {
	default
	eautoreconf
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install docdir="${EPREFIX}"/usr/share/doc/${PF}
	find "${D}" -name '*.la' -delete || die
}
