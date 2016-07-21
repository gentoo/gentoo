# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="High-performance Python library for predictive modeling"
HOMEPAGE="https://mlpy.fbk.eu/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
IUSE="doc"

RDEPEND="
	>=sci-libs/gsl-1.11
	>=dev-python/numpy-1.3[${PYTHON_USEDEP}]
	>=sci-libs/scipy-0.7[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )"

python_install_all() {
	distutils-r1_python_install_all
	if use doc; then
		pushd docs 2>/dev/null || die
		emake html
		dohtml -r build/html/*
		popd 2>/dev/null || die
	fi
}
