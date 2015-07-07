# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/ordereddict/ordereddict-1.1.ebuild,v 1.4 2015/07/07 16:44:15 zlogene Exp $

EAPI=5
PYTHON_COMPAT=( python2_7 )

inherit distutils-r1

DESCRIPTION="A drop-in substitute for Py2.7's new collections.OrderedDict that
works in Python 2.4-2.6."
HOMEPAGE="https://pypi.python.org/pypi/ordereddict"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

DEPEND="
	dev-python/setuptools[${PYTHON_USEDEP}]
"
RDEPEND=""
