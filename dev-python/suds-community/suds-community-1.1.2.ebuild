# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYPI_NO_NORMALIZE=1
PYTHON_REQ_USE="xml(+)"
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1 pypi

DESCRIPTION="Lightweight SOAP client"
HOMEPAGE="
	https://github.com/suds-community/suds/
	https://pypi.org/project/suds-community/
"

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
