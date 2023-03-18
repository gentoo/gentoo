# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=flit
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Infer properties from accessor methods"
HOMEPAGE="
	https://github.com/kalekundert/autoprop/
	https://pypi.org/project/autoprop/
"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

RDEPEND="
	>=dev-python/signature_dispatch-1.0.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
