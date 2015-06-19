# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/cliff-tablib/cliff-tablib-1.1.ebuild,v 1.2 2015/06/02 19:14:11 prometheanfire Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 python3_3 python3_4 )

inherit distutils-r1

DESCRIPTION="Formatter extensions of JSON, YAML, and HTML output in programs created by the cliff framework"
HOMEPAGE="https://github.com/dreamhost/cliff-tablib"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

KEYWORDS="~amd64 ~x86"
IUSE="doc examples"
LICENSE="Apache-2.0"
SLOT="0"

RDEPEND="dev-python/tablib[${PYTHON_USEDEP}]
		dev-python/cliff[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"

python_install_all() {
	# Use IUSE examples for installing the demoapp
	use examples && local EXAMPLES=( demoapp/. )
	use doc && local HTML_DOCS=( docs/build/html/. )
	distutils-r1_python_install_all
}
