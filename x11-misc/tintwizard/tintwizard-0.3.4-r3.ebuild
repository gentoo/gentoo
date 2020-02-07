# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 )

inherit python-single-r1

DESCRIPTION="GUI wizard which generates config files for tint2 panels"
HOMEPAGE="https://github.com/vanadey/tintwizard/"
SRC_URI="https://tintwizard.googlecode.com/files/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 x86"
IUSE=""
REQUIRED_USE="${PYTHON_REQUIRED_USE}"

DEPEND=""
RDEPEND="
	${PYTHON_DEPS}
	x11-misc/tint2
	$(python_gen_cond_dep '
		dev-python/pygtk:2[${PYTHON_MULTI_USEDEP}]
	')"

S="${WORKDIR}"

src_install() {
	python_newscript tintwizard.py tintwizard
	einstalldocs
}
