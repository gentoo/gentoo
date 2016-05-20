# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk"

inherit eutils python-single-r1 versionator

MY_P="${PN}$(get_version_component_range 1-2 ${PV})"
DATE="08.26.2013"

DESCRIPTION="Automated NOE assignment and NMR structure calculation"
HOMEPAGE="http://aria.pasteur.fr/"
SRC_URI="http://aria.pasteur.fr/archives/${MY_P}.2_${DATE}.tar.gz"

SLOT="0"
LICENSE="cns"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"

REQUIRED_USE="${PYTHON_REQUIRED_USE}"

RDEPEND="
	${PYTHON_DEPS}
	dev-tcltk/tix
	dev-lang/tk:0=
	>=dev-python/numpy-1.1[${PYTHON_USEDEP}]
	dev-python/matplotlib[${PYTHON_USEDEP},tk]
	>=sci-chemistry/cns-1.2.1-r7[aria,openmp]
	>=sci-chemistry/ccpn-2.2[${PYTHON_USEDEP}]
	sci-chemistry/clashlist
	sci-chemistry/procheck
	sci-libs/clashscore-db"
DEPEND="${RDEPEND}"

RESTRICT="fetch"

S="${WORKDIR}/${MY_P}"

pkg_nofetch(){
	einfo "Go to http://aria.pasteur.fr/archives/aria2.3.2.tar.gz/view, download ${A}"
	einfo "and place it in ${DISTDIR}"
}

pkg_setup() {
	python-single-r1_pkg_setup
}

src_test(){
	export CCPNMR_TOP_DIR=$(python_get_sitedir)
	export PYTHONPATH=.:${CCPNMR_TOP_DIR}/ccpn/python
	${PYTHON} check.py || die
}

src_install(){
	python_moduleinto ${PN}
	python_domodule src aria2.py
	python_moduleinto ${PN}/cns
	python_domodule cns/{protocols,toppar,src/helplib}

	if use examples; then
		insinto /usr/share/${P}/
		doins -r examples
	fi

	# ENV
	cat >> "${T}"/20aria <<- EOF
	ARIA2="$(python_get_sitedir)/${PN}"
	EOF

	doenvd "${T}"/20aria

	# Launch Wrapper
	cat >> "${T}"/aria <<- EOF
	#!/bin/sh
	export CCPNMR_TOP_DIR="$(python_get_sitedir)"
	export PYTHONPATH="$(python_get_sitedir)/ccpn/python"
	exec "${PYTHON}" -O "\${ARIA2}"/aria2.py \$@
	EOF

	dobin "${T}"/aria
	dosym aria /usr/bin/aria2

	dodoc README
	python_optimize "${D}/$(python_get_sitedir)"
}
