# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-lisp/ecls/ecls-10.4.1.ebuild,v 1.3 2014/08/10 20:41:36 slyfox Exp $

EAPI=3
inherit eutils multilib

MY_P=ecl-${PV}

DESCRIPTION="ECL is an embeddable Common Lisp implementation"
HOMEPAGE="http://common-lisp.net/project/ecl/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tar.gz"

LICENSE="BSD LGPL-2"
SLOT="0"
KEYWORDS="~amd64 ~ppc ~sparc ~x86"
IUSE="debug gengc precisegc threads +unicode X"

RDEPEND="dev-libs/gmp
		virtual/libffi
		>=dev-libs/boehm-gc-7.1[threads?]"
DEPEND="${RDEPEND}
		app-text/texi2html"
PDEPEND="dev-lisp/gentoo-init"

S="${WORKDIR}"/${MY_P}

pkg_setup() {
	if use gengc || use precisegc; then
		ewarn "USE flags gengc and precisegc are experimental"
		ewarn "Don't use them if you want a stable ecl"
	fi
}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-headers-gentoo.patch
}

src_configure() {
	econf \
		--with-system-gmp \
		--enable-boehm=system \
		--enable-longdouble \
		$(use_enable gengc) \
		$(use_enable precisegc) \
		$(use_with debug debug-cflags) \
		$(use_enable threads) \
		$(use_with threads __thread) \
		$(use_enable unicode) \
		$(use_with X x) \
		$(use_with X clx)
}

src_compile() {
	#parallel fails
	emake -j1 || die "Compilation failed"
}

src_install () {
	emake DESTDIR="${D}" install || die "Installation failed"

	dodoc ANNOUNCEMENT Copyright
	dodoc "${FILESDIR}"/README.Gentoo
	pushd build/doc
	newman ecl.man ecl.1
	newman ecl-config.man ecl-config.1
	popd
}
