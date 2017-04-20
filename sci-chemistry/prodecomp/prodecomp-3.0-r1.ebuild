# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 )
PYTHON_REQ_USE="tk"

inherit python-single-r1

DESCRIPTION="Decomposition-based analysis of NMR projections"
HOMEPAGE="http://www.lundberg.gu.se/nmr/software.php?program=PRODECOMP"
SRC_URI="mirror://gentoo/${P}.tar.bz2"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="examples"
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND="${PYTHON_DEPS}"
RDEPEND="${DEPEND}
	sci-libs/scipy[${PYTHON_USEDEP}]"

S="${WORKDIR}"/NMRProjAnalys

src_install() {
	python_export
	if use examples; then
		insinto /usr/share/${PN}
		doins -r ExampleData Results
	fi

	dodoc ProjTools/Manual.pdf
	rm -rf ProjTools/Manual.pdf ProdecompOutput || die

	python_moduleinto ${PN}
	python_domodule ProjTools/.
	python_optimize

	cat >> "${T}"/${PN} <<- EOF
	#!/bin/bash
	${PYTHON} -O $(python_get_sitedir)/${PN}/ProjAnalys.py \$@
	EOF
	dobin "${T}"/${PN}

	dosym ../../../../share/doc/${PF}/Manual.pdf "${PYTHON_SITEDIR##${EPREFIX}}"/${PN}/Manual.pdf
}
