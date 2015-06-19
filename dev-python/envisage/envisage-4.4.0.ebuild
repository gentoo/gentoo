# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/envisage/envisage-4.4.0.ebuild,v 1.3 2015/03/08 23:46:36 pacho Exp $

EAPI=5

# py2.6 fails testsuite horribly
PYTHON_COMPAT=python2_7

inherit distutils-r1 virtualx

DESCRIPTION="Enthought Tool Suite: Extensible application framework"
HOMEPAGE="http://code.enthought.com/projects/envisage"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="BSD"
SLOT="0"
KEYWORDS="amd64 x86 ~amd64-linux ~x86-linux"
IUSE="test"

RDEPEND=">=dev-python/traits-4[${PYTHON_USEDEP}]"
DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? (
		>=dev-python/traits-4[${PYTHON_USEDEP}]
		dev-python/apptools[${PYTHON_USEDEP}]
		media-fonts/font-cursor-misc
		media-fonts/font-misc-misc
	)"

# tests are buggy version after version
RESTRICT=test

python_test() {
	VIRTUALX_COMMAND="nosetests" virtualmake
}
