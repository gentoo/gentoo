# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/uritemplate/uritemplate-0.6.ebuild,v 1.6 2015/06/07 09:24:16 maekke Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4} pypy pypy3 )

inherit distutils-r1

DESCRIPTION="Python implementation of RFC6570, URI Template"
HOMEPAGE="https://pypi.python.org/pypi/uritemplate"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

SLOT="0"
LICENSE="Apache-2.0"
KEYWORDS="amd64 arm x86 ~amd64-linux ~x86-linux"
IUSE=""

RDEPEND="
	dev-python/simplejson[${PYTHON_USEDEP}]
	!<=dev-python/google-api-python-client-1.3"
DEPEND="${RDEPEND}"
