# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8
PYTHON_COMPAT=( python3_{8,9} )
DISTUTILS_USE_SETUPTOOLS=no

inherit distutils-r1

DESCRIPTION="BERT Serialization Library"
HOMEPAGE="https://pypi.org/project/bert/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~arm ~arm64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	dev-python/basho-erlastic[${PYTHON_USEDEP}]"

RDEPEND=""

PATCHES=( "${FILESDIR}/${PN}-2.0.0-remove-basestring-fix.patch" )
