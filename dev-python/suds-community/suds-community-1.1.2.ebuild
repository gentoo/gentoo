# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_REQ_USE="xml(+)"
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Lightweight SOAP client"
HOMEPAGE="
	https://github.com/suds-community/suds/
	https://pypi.org/project/suds-community/
"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"

DOCS=( README.md notes/. )

BDEPEND="
	test? (
		dev-python/six[${PYTHON_USEDEP}]
	)
"

distutils_enable_tests pytest
