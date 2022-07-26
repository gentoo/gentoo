# Copyright 2021-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..11} )
inherit python-single-r1

DESCRIPTION="Scripts to help retiring Gentoo developers"
HOMEPAGE="https://github.com/mgorny/gentoo-retirement-scripts/"
SRC_URI="
	https://github.com/mgorny/gentoo-retirement-scripts/archive/v${PV}.tar.gz
		-> ${P}.tar.gz
"

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64 ~arm ~arm64 ~x86"
REQUIRED_USE=${PYTHON_REQUIRED_USE}

RDEPEND="
	${PYTHON_DEPS}
	$(python_gen_cond_dep '
		dev-python/jinja[${PYTHON_USEDEP}]
		dev-python/lxml[${PYTHON_USEDEP}]
		dev-python/python-bugzilla[${PYTHON_USEDEP}]
	')"

src_compile() {
	python_fix_shebang .
}

src_install() {
	exeinto /opt/gentoo-retirement-scripts
	doexe *.py
	insinto /opt/gentoo-retirement-scripts
	doins *.template
}
