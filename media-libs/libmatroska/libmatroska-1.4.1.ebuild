# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/media-libs/libmatroska/libmatroska-1.4.1.ebuild,v 1.9 2014/03/24 15:04:32 ago Exp $

EAPI=5

inherit flag-o-matic eutils multilib toolchain-funcs

DESCRIPTION="Extensible multimedia container format based on EBML"
HOMEPAGE="http://www.matroska.org/ https://github.com/Matroska-Org/libmatroska/"
SRC_URI="https://github.com/Matroska-Org/libmatroska/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="GPL-2"
SLOT="0/6" # subslot = soname major version
KEYWORDS="alpha amd64 arm ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-linux"
IUSE="static-libs"
RESTRICT="test"

DEPEND=">=dev-libs/libebml-1.3.0:="
RDEPEND="${DEPEND}"

S=${WORKDIR}/${PN}-release-${PV}/make/linux

src_prepare() {
	epatch "${FILESDIR}"/${P}-flags.patch
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

	emake DESTDIR="${D}" prefix="${EPREFIX}"/usr libdir="${EPREFIX}"/usr/$(get_libdir) ${targets}
	dodoc "${WORKDIR}"/${PN}-release-${PV}/ChangeLog
}
