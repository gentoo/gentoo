# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7..9} )

inherit distutils-r1

DESCRIPTION="Infer properties from accessor methods"
HOMEPAGE="
	https://github.com/kalekundert/autoprop/
	https://pypi.org/project/autoprop/"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

distutils_enable_tests pytest
