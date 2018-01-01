# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

MY_PN=TeXamator

DESCRIPTION="A program aimed at helping you making your exercise sheets"
HOMEPAGE="http://alexisfles.ch/en/texamator/texamator.html
	https://github.com/alexisflesch/texamator"
SRC_URI="http://snouffy.free.fr/blog-en/public/${MY_PN}/${MY_PN}.v.${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="app-text/dvipng
	dev-python/PyQt4[${PYTHON_USEDEP}]
	virtual/latex-base
	${PYTHON_DEPS}"
RDEPEND="${DEPEND}"

S=${WORKDIR}/${MY_PN}

src_compile() {
	cat >> ${PN} <<-_EOF_ || die
		#!/bin/sh
		cd /usr/lib/${MY_PN} &&
		exec "${EPYTHON}" ${MY_PN}.py
	_EOF_
}

src_install() {
	dobin ${PN}

	python_moduleinto /usr/lib/${MY_PN}
	python_domodule ${MY_PN}.py partielatormods {ts,ui}_files
}
