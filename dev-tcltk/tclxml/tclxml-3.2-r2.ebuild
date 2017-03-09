# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

inherit eutils multilib

DESCRIPTION="Pure Tcl implementation of an XML parser"
HOMEPAGE="http://tclxml.sourceforge.net/"
SRC_URI="mirror://sourceforge/tclxml/${P}.tar.gz"

IUSE="debug threads"
LICENSE="BSD"
SLOT="0"
KEYWORDS="alpha amd64 ppc sparc x86"

DEPEND="
	>=dev-lang/tcl-8.2:0
	>=dev-libs/libxml2-2.6.9
	dev-libs/libxslt
	>=dev-tcltk/tcllib-1.2
	dev-libs/expat
	!dev-tcltk/tcldom"
#	test? ( dev-tcltk/tclparser )
RDEPEND="${DEPEND}"

RESTRICT="test"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-fix-implicit-declarations.patch \
		"${FILESDIR}"/${P}-format-security.patch
}

src_configure() {
	local myconf=""

	use threads && myconf="${myconf} --enable-threads"

	econf ${myconf} \
		--with-xml2-config="${EPREFIX}"/usr/bin/xml2-config \
		--with-xslt-config="${EPREFIX}"/usr/bin/xslt-config \
		--with-tclinclude="${EPREFIX}"/usr/include \
		--with-tcl="${EPREFIX}"/usr/$(get_libdir) \
		$(use_enable amd64 64bit) \
		$(use_enable debug symbols)
}

src_install() {
	default
	dohtml doc/*.html
}
