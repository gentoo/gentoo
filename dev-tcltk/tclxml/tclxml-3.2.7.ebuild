# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils multilib

DESCRIPTION="Pure Tcl implementation of an XML parser"
HOMEPAGE="http://tclxml.sourceforge.net/"
SRC_URI="https://github.com/wjoye/${PN}/archive/v${PV}.tar.gz
	-> ${P}.tar.gz"

IUSE="debug threads"
LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha ~amd64 ~ppc ~sparc ~x86"

DEPEND="
	>=dev-lang/tcl-8.2:0
	>=dev-libs/libxml2-2.6.9
	dev-libs/libxslt
	>=dev-tcltk/tcllib-1.2
	dev-libs/expat"
#	test? ( dev-tcltk/tclparser )
RDEPEND="${DEPEND}"

RESTRICT="test"

PATCHES=(
		"${FILESDIR}"/${PN}-3.2-fix-implicit-declarations.patch
)

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
