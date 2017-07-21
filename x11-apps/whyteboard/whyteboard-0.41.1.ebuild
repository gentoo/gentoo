# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit eutils python-single-r1 multilib

DESCRIPTION="A simple image, PDF and postscript file annotator"
HOMEPAGE="http://whyteboard.org/"
SRC_URI="
	mirror://sourceforge/${PN}/${P}.tar.gz
	https://dev.gentoo.org/~lxnay/${PN}/${PN}.png"

LICENSE="ISC"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	dev-python/wxpython:*[${PYTHON_USEDEP}]
	media-gfx/imagemagick"

src_install() {
	doicon "${DISTDIR}"/${PN}.png
	domenu "${FILESDIR}"/${PN}.desktop

	dodoc CHANGELOG.txt DEVELOPING.txt README.txt TODO.txt

	python_domodule images locale ${PN} ${PN}-help ${PN}.py

	cat >> "${T}/${PN}" <<- EOF
	#!/bin/sh
	exec ${PYTHON} -O "$(python_get_sitedir)/${PN}/${PN}.py"
	EOF
	dobin "${T}/${PN}"

	python_optimize
}

pkg_preinst() {
	echo
	elog "This application is very experimental and some features"
	elog "are not yet implemented, however you can live with it"
	echo
}
