# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

MYPN=TclXML
MYP=${MYPN}-${PV}

DESCRIPTION="Pure Tcl implementation of an XML parser"
HOMEPAGE="https://github.com/flightaware/TclXML"
SRC_URI="https://github.com/flightaware/TclXML/archive/refs/tags/v${PV}.tar.gz
	-> ${MYP}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~alpha amd64 ppc sparc x86"
IUSE="debug threads"

DEPEND="
	>=dev-lang/tcl-8.2:=
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

S="${WORKDIR}"/${MYP}

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
