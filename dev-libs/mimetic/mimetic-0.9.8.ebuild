# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit autotools

DESCRIPTION="C++ MIME library designed to be easy to use and integrate, fast and efficient."
HOMEPAGE="http://www.codesink.org/mimetic_mime_library.html"
SRC_URI="http://www.codesink.org/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE="doc examples"

DEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	default

	sed -i -e "s|../doxygen.css|doxygen.css|" doc/header.html || die

	mv configure.in configure.ac || die
	eautoreconf
}

src_configure() {
	econf --disable-static
}

src_compile() {
	default
	use doc && emake -C doc docs
}

src_install() {
	default

	use doc && dodoc -r doc/html/

	if use examples ; then
		docinto examples
		dodoc examples/{README,TODO,test.msg,*.cxx,*.h}
	fi

	rm "${D}"/usr/$(get_libdir)/libmimetic.la || die
}
