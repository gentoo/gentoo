# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1 eutils

DESCRIPTION="Python module to read VO tables into a numpy array"
HOMEPAGE="https://trac6.assembla.com/astrolib/wiki"
SRC_URI="http://stsdas.stsci.edu/astrolib/${P}.tar.gz
	test? ( http://svn6.assembla.com/svn/astrolib/trunk/vo/test/wfpc2_all.xml.gz )"

IUSE="examples test"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~amd64-linux ~x86-linux"
LICENSE="BSD"

RDEPEND="
	dev-libs/expat
	!<dev-python/astropy-0.3"
DEPEND="${RDEPEND}"

# slow and buggy tests
RESTRICT="test"

python_prepare_all() {
	epatch "${FILESDIR}"/${PN}-0.6-expat.patch
	use test && cp "${WORKDIR}"/wfpc2_all.xml test
}

python_test() {
	cd test || die
	ln -s "${S}"/lib/data "${BUILD_DIR}/lib/vo/data" || die
	PYTHONPATH="${BUILD_DIR}/lib" "${EPYTHON}" benchmarks.py || die
}

python_install_all() {
	if use examples; then
		insinto /usr/share/doc/${PF}/
		doins -r examples
	fi
}
