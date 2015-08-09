# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

EGIT_REPO_URI="git://git.samba.org/ctdb.git"
inherit autotools eutils git-2 multilib-minimal

DESCRIPTION="A cluster implementation of the TDB database used to store temporary data"
HOMEPAGE="http://ctdb.samba.org/"
LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND=">=dev-libs/popt-1.16-r2[${MULTILIB_USEDEP}]"
RDEPEND="${DEPEND}"

src_prepare() {
	AT_M4DIR="-I libreplace -I lib/replace -I ../libreplace -I ../replace"
	AT_M4DIR+=" -I lib/talloc -I talloc -I ../talloc"
	AT_M4DIR+=" -I lib/tdb -I tdb -I ../tdb"
	AT_M4DIR+=" -I lib/popt -I popt -I ../popt"
	AT_M4DIR+=" -I lib/tevent"

	rm -rf autom4te.cache
	rm -f configure config.h.in

	autotools_run_tool autoheader ${AT_M4DIR} || die "running autoheader failed"
	eautoconf ${AT_M4DIR}
}

src_prepare() {
	epatch "${PATCHES[@]}"
	epatch_user

	# custom, broken Makefile
	multilib_copy_sources
}

multilib_src_configure() {
	econf \
		--docdir="${EPREFIX}/usr/share/doc/${PF}" \
		--localstatedir="${EPREFIX}/var/lib" \
		--with-logdir="${EPREFIX}/var/log/${PN}"
}

multilib_src_install_all() {
	einstalldocs
	dohtml web/* doc/*.html
}
