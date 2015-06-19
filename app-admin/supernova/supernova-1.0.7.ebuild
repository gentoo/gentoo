# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/app-admin/supernova/supernova-1.0.7.ebuild,v 1.1 2014/11/01 20:29:55 alunduil Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit bash-completion-r1 distutils-r1 vcs-snapshot

DESCRIPTION="novaclient wrapper for multiple nova environments"
HOMEPAGE="https://github.com/rackerhacker/supernova"
SRC_URI="https://github.com/major/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64"
IUSE="doc examples"

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	doc? ( dev-python/sphinx[${PYTHON_USEDEP}] )
"
RDEPEND="
	>=dev-python/keyring-0.9.2[${PYTHON_USEDEP}]
	dev-python/rackspace-novaclient[${PYTHON_USEDEP}]
"

python_compile_all() {
	use doc && emake -C docs html
}

python_install_all() {
	use doc && local HTML_DOCS=( docs/_build/html/. )
	use examples && local EXAMPLES=( example_configs/. )

	distutils-r1_python_install_all

	newbashcomp contrib/${PN}-completion.bash ${PN}
}
