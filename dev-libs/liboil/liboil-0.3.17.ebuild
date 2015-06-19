# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-libs/liboil/liboil-0.3.17.ebuild,v 1.10 2012/10/29 00:56:43 tetromino Exp $

EAPI=2
inherit eutils flag-o-matic multilib

DESCRIPTION="Library of simple functions that are optimized for various CPUs"
HOMEPAGE="http://liboil.freedesktop.org/"
SRC_URI="http://liboil.freedesktop.org/download/${P}.tar.gz"

LICENSE="BSD-2"
SLOT="0.3"
KEYWORDS="alpha amd64 arm hppa ia64 ~mips ppc ppc64 sh sparc x86 ~x86-fbsd"
IUSE="doc +examples test"

RDEPEND="examples? ( dev-libs/glib:2 )"
DEPEND="${RDEPEND}
	virtual/pkgconfig
	doc? ( >=dev-util/gtk-doc-1 )"

src_prepare() {
	if ! use examples; then
		sed "s/^\(SUBDIRS =.*\)examples\(.*\)$/\1\2/" \
			-i Makefile.am Makefile.in || die
	fi

	if ! use test; then
		sed "s/^\(SUBDIRS =.*\)testsuite\(.*\)$/\1\2/" \
			-i Makefile.am Makefile.in || die
	fi

	has x32 $(get_all_abis) && epatch "${FILESDIR}"/${PN}-0.3.17-x32.patch
}

src_configure() {
	strip-flags
	filter-flags -O?
	append-flags -O2

	econf \
		--disable-dependency-tracking \
		$(use_enable doc gtk-doc) \
		--with-html-dir=/usr/share/doc/${PF}/html
}

src_install() {
	emake DESTDIR="${D}" install || die
	dodoc AUTHORS BUG-REPORTING HACKING NEWS README || die
}

pkg_postinst() {
	if ! use examples; then
		ewarn "You have disabled examples USE flag. Beware that upstream might"
		ewarn "want the output of some utilities that are only built with"
		ewarn "USE='examples' if you report bugs to them."
	fi
}
