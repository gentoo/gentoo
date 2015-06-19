# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/requests-oauthlib/requests-oauthlib-0.4.1.ebuild,v 1.4 2015/04/08 08:05:24 mgorny Exp $

EAPI=5

PYTHON_COMPAT=( python{2_7,3_3,3_4} )

inherit distutils-r1

DESCRIPTION="This project provides first-class OAuth library support for Requests"
HOMEPAGE="https://github.com/requests/requests-oauthlib"
SRC_URI="https://github.com/requests/${PN}/archive/v${PV}.tar.gz -> ${P}.tar.gz"

SLOT="0"
LICENSE="ISC"
KEYWORDS="amd64 x86"
IUSE="test"

DEPEND="test? ( dev-python/mock[${PYTHON_USEDEP}] )"
RDEPEND="
	>=dev-python/requests-2.0.0[${PYTHON_USEDEP}]
	>=dev-python/oauthlib-0.6.2[${PYTHON_USEDEP}]"

#Refrain from a doc build for now
#python_compile_all() {
#	use doc && emake -C docs html
#}

python_test() {
	esetup.py test
}
