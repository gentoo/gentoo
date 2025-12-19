# Copyright 1999-2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_REQ_USE="xml(+)"
PYTHON_COMPAT=( python3_{11..14} )

inherit distutils-r1 pypi

DESCRIPTION="Lightweight SOAP client"
HOMEPAGE="
	https://github.com/suds-community/suds/
	https://pypi.org/project/suds-community/
"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 arm64 x86"

DOCS=( README.md notes/. )

distutils_enable_tests pytest
