# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-tex/texamator/texamator-1.7.5.ebuild,v 1.1 2012/08/02 23:26:59 pesa Exp $

EAPI=4
PYTHON_DEPEND="2"

inherit multilib python

MY_PN=TeXamator

DESCRIPTION="A program aimed at helping you making your exercise sheets"
HOMEPAGE="http://snouffy.free.fr/blog-en/index.php/category/TeXamator"
SRC_URI="http://snouffy.free.fr/blog-en/public/${MY_PN}/${MY_PN}.v.${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="app-text/dvipng
	dev-python/PyQt4
	virtual/latex-base"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}

pkg_setup() {
	python_set_active_version 2
	python_pkg_setup
}

src_install() {
	python_need_rebuild

	dobin "${FILESDIR}"/${PN}

	insinto /usr/$(get_libdir)/${MY_PN}
	doins -r ${MY_PN}.py partielatormods {ts,ui}_files
}

pkg_postinst() {
	python_mod_optimize /usr/$(get_libdir)/${MY_PN}
}

pkg_postrm() {
	python_mod_cleanup /usr/$(get_libdir)/${MY_PN}
}
