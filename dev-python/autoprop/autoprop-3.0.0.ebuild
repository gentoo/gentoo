# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DISTUTILS_USE_SETUPTOOLS=no
PYTHON_COMPAT=( python3_{7..10} )

inherit distutils-r1

DESCRIPTION="Infer properties from accessor methods"
HOMEPAGE="
	https://github.com/kalekundert/autoprop/
	https://pypi.org/project/autoprop/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="
	dev-python/signature_dispatch[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
