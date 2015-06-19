# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/wehjit/wehjit-0.2.2-r1.ebuild,v 1.2 2015/04/08 08:04:58 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A Python web-widget library"
HOMEPAGE="http://jderose.fedorapeople.org/wehjit"
SRC_URI="http://jderose.fedorapeople.org/${PN}/${PV}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE="test"

RDEPEND="dev-python/genshi
		dev-python/assets[${PYTHON_USEDEP}]
		dev-python/paste[${PYTHON_USEDEP}]
		dev-python/pygments[${PYTHON_USEDEP}]
		"
DEPEND="${RDEPEND}"

DOCS=( README NEWS )

PATCHES=( "${FILESDIR}"/${P}-SkipTest.patch )

python_test() {
	if [[ "${EPYTHON:6:3}" == '2.6' ]]; then
		nosetests -I test_app* -e=*getitem
	else
		nosetests
	fi
}
