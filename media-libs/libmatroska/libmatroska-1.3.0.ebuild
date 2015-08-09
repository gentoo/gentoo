# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="4"

inherit flag-o-matic eutils multilib toolchain-funcs

DESCRIPTION="Extensible multimedia container format based on EBML"
HOMEPAGE="http://www.matroska.org/"
SRC_URI="http://www.bunkus.org/videotools/mkvtoolnix/sources/${P}.tar.bz2"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-linux"
IUSE="static-libs"
RESTRICT="test"

DEPEND=">=dev-libs/libebml-1.2.1"
RDEPEND="${DEPEND}"

S="${WORKDIR}/${P}/make/linux"

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.0.0-respectflags.patch"
}

src_compile() {
	local targets="sharedlib"
	use static-libs && targets+=" staticlib"

	#fixes locale for gcc3.4.0 to close bug 52385
	append-flags $(test-flags -finput-charset=ISO8859-15)

	emake PREFIX="${EPREFIX}"/usr \
		LIBEBML_INCLUDE_DIR="${EPREFIX}"/usr/include/ebml \
		LIBEBML_LIB_DIR="${EPREFIX}"/usr/$(get_libdir) \
		CXX="$(tc-getCXX)" \
		AR="$(tc-getAR)" \
		${targets}
}

src_install() {
	local targets="install_sharedlib install_headers"
	use static-libs && targets+=" install_staticlib"

	emake prefix="${ED}/usr" libdir="${ED}/usr/$(get_libdir)" ${targets}
	dodoc "${WORKDIR}/${P}/ChangeLog"
}
