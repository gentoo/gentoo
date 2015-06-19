# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/cgicc/cgicc-3.2.9.ebuild,v 1.3 2012/04/10 12:39:03 scarabeus Exp $

EAPI=4

DESCRIPTION="A C++ class library for writing CGI applications"
HOMEPAGE="http://www.gnu.org/software/cgicc/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="LGPL-3 doc? ( FDL-1.2 )"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

src_configure() {
	if ! use doc; then
		sed -i \
			-e 's/^\(SUBDIRS = .*\) doc \(.*\)/\1 \2/' \
			Makefile.in || die
	fi

	econf \
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--disable-dependency-tracking \
		--disable-demos
}

src_install() {
	default

	dodoc AUTHORS BUGS ChangeLog NEWS README* THANKS

	if use doc; then
		insinto /usr/share/doc/${PF}/contrib
		doins contrib/*.{cpp,h} contrib/README

		insinto /usr/share/doc/${PF}/demo
		doins -r demo/*.{cpp,h} demo/images demo/README
	fi
}
