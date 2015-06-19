# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/net-libs/libasyncns/libasyncns-0.8-r3.ebuild,v 1.11 2014/08/10 20:48:57 slyfox Exp $

EAPI=5
inherit eutils flag-o-matic libtool multilib multilib-minimal

DESCRIPTION="C library for executing name service queries asynchronously"
HOMEPAGE="http://0pointer.de/lennart/projects/libasyncns/"
SRC_URI="http://0pointer.de/lennart/projects/libasyncns/${P}.tar.gz"

SLOT="0"

LICENSE="LGPL-2.1"
KEYWORDS="alpha amd64 arm hppa ia64 ppc ppc64 ~sh sparc x86 ~amd64-linux ~x86-linux"

IUSE="doc debug"

RDEPEND=""
DEPEND="doc? ( app-doc/doxygen )"

src_prepare() {
	# fix libdir in pkgconfig file
	epatch "${FILESDIR}/${P}-libdir.patch"
	elibtoolize
}

multilib_src_configure() {
	# libasyncns uses assert()
	use debug || append-cppflags -DNDEBUG

	ECONF_SOURCE=${S} \
	econf \
		--docdir="${EPREFIX}"/usr/share/doc/${PF} \
		--htmldir="${EPREFIX}"/usr/share/doc/${PF}/html \
		--disable-dependency-tracking \
		--disable-lynx \
		--disable-static
}

multilib_src_compile() {
	emake || die "emake failed"

	if multilib_is_native_abi && use doc; then
		doxygen doxygen/doxygen.conf || die "doxygen failed"
	fi
}

multilib_src_install() {
	emake DESTDIR="${D}" install || die "emake install failed"

	if multilib_is_native_abi && use doc; then
		docinto apidocs
		dohtml html/*
	fi
}

multilib_src_install_all() {
	find "${D}" -name '*.la' -delete
}
