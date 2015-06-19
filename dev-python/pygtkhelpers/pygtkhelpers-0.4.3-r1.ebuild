# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/pygtkhelpers/pygtkhelpers-0.4.3-r1.ebuild,v 1.1 2014/12/25 12:44:52 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="PyGTKHelpers is a library to assist the building of PyGTK applications"
HOMEPAGE="http://packages.python.org/pygtkhelpers/ http://pypi.python.org/pypi/pygtkhelpers"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"
IUSE="doc examples"

RDEPEND="dev-python/pygtk[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx )"

python_prepare_all() {
	# docs/_static/scope.jpg does not exist.
	sed -e "s/^\(html_logo =.*\)/#\1/" -i docs/conf.py || die "sed failed"

	distutils-r1_python_prepare_all
}

python_compile_all() {
	if use doc; then
		esetup.py build_sphinx
	fi
}

python_install_all() {
	distutils-r1_python_install_all

	if use doc; then
		cd "${BUILD_DIR}"/sphinx/html || die
		docinto html
		dodoc -r [a-z]* _images _static
		cd - >/dev/null || die
	fi

	if use examples; then
		docinto examples
		dodoc -r examples/.
	fi
}
