# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_REQ_USE="xml(+)"
# Tests fail with PyPy3
PYTHON_COMPAT=( python3_{7,8,9} )

inherit distutils-r1

MY_PN="${PN}-community"
DESCRIPTION="Lightweight SOAP client"
HOMEPAGE="https://github.com/suds-community/suds"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"

# https://github.com/suds-community/suds/pull/40
PATCHES=( "${FILESDIR}/${P}-fix-optimization.patch" )

DOCS=( README.md notes/. )

distutils_enable_tests pytest
