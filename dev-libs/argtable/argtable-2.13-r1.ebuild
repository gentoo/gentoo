# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
inherit versionator

DESCRIPTION="An ANSI C library for parsing GNU-style command-line options with minimal fuss"
HOMEPAGE="http://argtable.sourceforge.net/"

MY_PV="$(replace_version_separator 1 '-')"
MY_P=${PN}${MY_PV}

SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="LGPL-2"
SLOT="0"
KEYWORDS="~alpha amd64 ~ia64 ~ppc ~ppc64 ~sparc x86"
IUSE="doc debug examples static-libs"

S="${WORKDIR}/${MY_P}"

src_configure() {
	econf \
		$(use_enable debug) \
		$(use_enable static-libs static)
}

src_install() {
	emake DESTDIR="${D}" install
	rm -rf "${D}"/usr/share/doc/${PF}/

	dodoc AUTHORS ChangeLog NEWS README

	if use doc ; then
		cd "${S}/doc"
		dodoc *.pdf *.ps
		docinto html
		dodoc *.html *.gif
	fi

	if use examples ; then
		cd "${S}/example"
		docinto examples
		dodoc Makefile *.[ch] README.txt
	fi

	find "${ED}" -name "*.la" -delete || die "failed to delete .la files"
}
