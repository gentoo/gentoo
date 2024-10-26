# Copyright 2021-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit autotools

DESCRIPTION="Threading library used by dar archiver"
HOMEPAGE="https://sourceforge.net/projects/libthreadar/"
SRC_URI="https://downloads.sourceforge.net/libthreadar/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ppc sparc x86"

src_prepare() {
	default

	# don't build examples, they are not installed
	sed -i -e '/^SUBDIRS =/d' doc/Makefile.am || die
	eautoreconf
}

src_configure() {
	econf --disable-build-html
}

src_install() {
	emake DESTDIR="${D}" pkgdatadir="${EPREFIX}"/usr/share/doc/${PF}/html install

	einstalldocs
	rm -r "${ED}"/usr/share/doc/${PF}/html || die

	find "${ED}" -name '*.la' -delete || die
}
