# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=4
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="3.* 2.7-pypy-* *-jython"

inherit distutils

DESCRIPTION="Python interface for the GNU scientific library (gsl)"
HOMEPAGE="http://pygsl.sourceforge.net/"
SRC_URI="mirror://sourceforge/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="GPL-2"
KEYWORDS="amd64 ~ppc ~ppc64 x86 ~amd64-linux ~x86-linux"
IUSE="examples"

DEPEND="sci-libs/gsl
	dev-python/numpy"
RDEPEND="${DEPEND}"

src_test() {
	testing() {
		cd "${S}/tests"
		PYTHONPATH=$(ls -d ../build-${PYTHON_ABI}/lib*) "$(PYTHON)" run_test.py
	}
	python_execute_function testing
}

src_install() {
	distutils_src_install
	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r examples || die "install examples failed"
	fi
}
