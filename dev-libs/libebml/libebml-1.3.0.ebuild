# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/libebml/libebml-1.3.0.ebuild,v 1.10 2014/03/24 15:04:17 ago Exp $

EAPI=5

inherit eutils multilib toolchain-funcs

DESCRIPTION="Extensible binary format library (kinda like XML)"
HOMEPAGE="http://www.matroska.org/ https://github.com/Matroska-Org/libebml/"
SRC_URI="https://github.com/Matroska-Org/${PN}/archive/release-${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="LGPL-2.1"
SLOT="0/4" # subslot = soname major version
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~amd64-fbsd ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE="debug static-libs"

S=${WORKDIR}/${PN}-release-${PV}/make/linux

src_prepare() {
	epatch "${FILESDIR}"/${P}-makefile.patch

	sed -i "s:\(DEBUGFLAGS=\)-g :\1:" Makefile || die
}

src_compile() {
	local targets
	if [[ ${CHOST} != *-darwin* ]] ; then
		targets="sharedlib"
	else
		targets="macholib"
	fi
	use static-libs && targets+=" staticlib"

	# keep the prefix in here to make sure the binary is built with a correct
	# install_name on Darwin
	emake \
		prefix="${EPREFIX}"/usr \
		AR="$(tc-getAR)" \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		$(use debug && echo DEBUG=yes || echo DEBUG=no) \
		${targets}
}

src_install() {
	local targets="install_headers"
	if [[ ${CHOST} != *-darwin* ]] ; then
		targets+=" install_sharedlib"
	else
		targets+=" install_macholib"
	fi
	use static-libs && targets+=" install_staticlib"

	emake \
		DESTDIR="${D}" \
		prefix="${EPREFIX}"/usr \
		libdir="${EPREFIX}"/usr/$(get_libdir) \
		${targets}

	dodoc "${WORKDIR}"/${PN}-release-${PV}/ChangeLog
}
