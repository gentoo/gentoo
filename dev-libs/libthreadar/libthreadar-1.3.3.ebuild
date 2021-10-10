# Copyright 2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Threading library used by dar archiver"
HOMEPAGE="https://sourceforge.net/projects/libthreadar/"
SRC_URI="mirror://sourceforge/libthreadar/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"

src_install() {
	emake DESTDIR="${D}" pkgdatadir="${EPREFIX}"/usr/share/doc/${PF}/html install

	einstalldocs

	find "${ED}" -name '*.la' -delete || die
}
