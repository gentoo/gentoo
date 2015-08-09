# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=2
inherit eutils multilib

MY_P=ecl-${PV}

DESCRIPTION="ECL is an embeddable Common Lisp implementation"
HOMEPAGE="http://common-lisp.net/project/ecl/"
SRC_URI="mirror://sourceforge/${PN}/${MY_P}.tgz"

LICENSE="BSD LGPL-2"
SLOT="0"
KEYWORDS="amd64 ~ppc ~sparc x86"
IUSE="X doc +threads +unicode"

RDEPEND="dev-libs/gmp
		virtual/libffi
		>=dev-libs/boehm-gc-7.1[threads?]"
DEPEND="${RDEPEND}"
PDEPEND="dev-lisp/gentoo-init"

S="${WORKDIR}"/${MY_P}

src_prepare() {
	epatch "${FILESDIR}"/${PV}-headers-gentoo.patch
}

src_configure() {
	econf \
		--with-system-gmp \
		--enable-boehm=system \
		--enable-gengc \
		--enable-longdouble \
		$(use_enable threads) \
		$(use_with threads __thread) \
		$(use_enable unicode) \
		$(use_with X x) \
		$(use_with X clx)
}

src_compile() {
	#parallel fails
	emake -j1 || die "emake failed"
	if use doc; then
		pushd build/doc
		emake || die "emake doc failed"
		popd
	fi
}

src_install () {
	emake DESTDIR="${D}" install || die "emake install failed"
	dodoc ANNOUNCEMENT Copyright
	dodoc "${FILESDIR}"/README.Gentoo
	pushd build/doc
	newman ecl.man ecl.1
	newman ecl-config.man ecl-config.1
	if use doc; then
		doinfo *.info || die "doinfo failed"
	fi
	popd
}
