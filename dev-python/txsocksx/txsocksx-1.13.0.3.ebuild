# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/txsocksx/txsocksx-1.13.0.3.ebuild,v 1.1 2015/01/06 03:34:13 mrueg Exp $

EAPI=5

PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="Twisted client endpoints for SOCKS{4,4a,5}"
HOMEPAGE="https://github.com/habnabit/txsocksx"
SRC_URI="mirror://pypi/t/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/vcversioner[${PYTHON_USEDEP}]"
RDEPEND=">=dev-python/parsley-1.2[${PYTHON_USEDEP}]
	dev-python/pyopenssl[${PYTHON_USEDEP}]
	dev-python/twisted-core[${PYTHON_USEDEP},crypt]
	dev-python/twisted-web[${PYTHON_USEDEP}]
	dev-python/zope-interface[${PYTHON_USEDEP}]"
