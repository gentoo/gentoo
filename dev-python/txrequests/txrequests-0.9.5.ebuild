# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6
PYTHON_COMPAT=( python2_7)

inherit distutils-r1

DESCRIPTION="Asynchronous Python HTTP for Humans"
HOMEPAGE="https://github.com/tardyp/txrequests"
SRC_URI="mirror://pypi/${P:0:1}/${PN}/${P}.tar.gz"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-python/requests-1.2.0[${PYTHON_USEDEP}]
	|| (
		dev-python/twisted[${PYTHON_USEDEP}]
		>=dev-python/twisted-core-9.0.0[${PYTHON_USEDEP}]
	)
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
"
