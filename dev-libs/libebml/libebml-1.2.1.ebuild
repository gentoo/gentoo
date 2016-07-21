# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2

inherit eutils multilib toolchain-funcs

DESCRIPTION="Extensible binary format library (kinda like XML)"
HOMEPAGE="http://www.matroska.org/"
SRC_URI="http://www.bunkus.org/videotools/mkvtoolnix/sources/${P}.tar.bz2"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 sparc x86 ~x86-fbsd ~x86-freebsd ~amd64-linux ~x86-linux ~ppc-macos"
IUSE=""

DEPEND=""
RDEPEND=""

S="${WORKDIR}/${P}/make/linux"

src_prepare() {
	epatch "${FILESDIR}"/${PN}-1.2.0-makefile-fixup.patch
}

src_compile() {
	# keep the prefix in here to make sure the binary is built with a correct
	# install_name on Darwin
	emake \
		prefix="${EPREFIX}/usr" \
		CC="$(tc-getCC)" \
		CXX="$(tc-getCXX)" \
		|| die "emake failed"
}

src_install() {
	emake \
		DESTDIR="${D}" \
		prefix="${EPREFIX}/usr" \
		libdir="${EPREFIX}/usr/$(get_libdir)" \
		install || die "emake install failed"

	dodoc "${WORKDIR}/${P}/ChangeLog"
}
