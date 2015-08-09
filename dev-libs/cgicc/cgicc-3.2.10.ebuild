# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit eutils

DESCRIPTION="A C++ class library for writing CGI applications"
HOMEPAGE="http://www.gnu.org/software/cgicc/"
SRC_URI="mirror://gnu/${PN}/${P}.tar.gz"

LICENSE="LGPL-3 doc? ( FDL-1.2 )"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="doc static-libs"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	epatch "${FILESDIR}/${PV}-fix-pkgconfig.patch"
}

src_configure() {
	if ! use doc; then
		sed -i \
			-e 's/^\(SUBDIRS = .*\) doc \(.*\)/\1 \2/' \
			Makefile.in || die
	fi

	econf \
		--htmldir="${EPREFIX}/usr/share/doc/${PF}/html" \
		--disable-dependency-tracking \
		--disable-demos \
		$(use_enable static-libs static)
}

src_install() {
	default
	prune_libtool_files

	if use doc; then
		insinto /usr/share/doc/${PF}/contrib
		doins contrib/*.{cpp,h} contrib/README

		insinto /usr/share/doc/${PF}/demo
		doins -r demo/*.{cpp,h} demo/images demo/README
	fi
}
