# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{4,5} )

inherit distutils-r1 eutils multilib

DESCRIPTION="Provides an interface to FITS formatted files under python"
HOMEPAGE="http://www.stsci.edu/resources/software_hardware/pyfits"
SRC_URI="mirror://pypi/p/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~x86 ~x86-fbsd ~amd64-linux ~x86-linux"
IUSE="doc test"

RDEPEND="
	dev-python/numpy[${PYTHON_USEDEP}]
	sci-libs/cfitsio:0="
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	>=dev-python/d2to1-0.2.5[${PYTHON_USEDEP}]
	>=dev-python/stsci-distutils-0.3[${PYTHON_USEDEP}]
	doc? (
		dev-python/matplotlib[${PYTHON_USEDEP}]
		$(python_gen_cond_dep 'dev-python/numpydoc[${PYTHON_USEDEP}]' 'python*')
		dev-python/sphinxcontrib-programoutput[${PYTHON_USEDEP}]
		dev-python/stsci-sphinxext[${PYTHON_USEDEP}]
		 )
	test? ( dev-python/nose[${PYTHON_USEDEP}] )"

PATCHES=( "${FILESDIR}"/${PN}-3.2.1-unbundle-cfitsio.patch )

python_prepare_all() {
	sed -i \
		-e "s/\(hook_package_dir = \)lib/\1$(get_libdir)/g" \
		"${S}"/setup.cfg || die

	# https://github.com/spacetelescope/PyFITS/issues/95
	sed -e "s/except UserWarning, w/except UserWarning as w/" \
		-i pyfits/scripts/fitscheck.py || die

	distutils-r1_python_prepare_all
}

python_compile_all() {
	use doc && emake -C docs html
}

python_test() {
	cd "${BUILD_DIR}"/lib* || die
	nosetests --verbose || die
}

python_install() {
	distutils-r1_python_install
	local binary
	for binary in "${ED}"/usr/bin/* "${D}$(python_get_scriptdir)"/*; do
		einfo "Renaming ${binary} to ${binary}-${PN}"
		mv ${binary}{,-${PN}} || die "failed renaming"
	done
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/build/html/. )
	DOCS=( FAQ.txt CHANGES.txt )
	distutils-r1_python_install_all
}
