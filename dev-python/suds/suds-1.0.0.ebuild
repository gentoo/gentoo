# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_REQ_USE="xml(+)"
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

MY_PN="${PN}-community"
DESCRIPTION="Lightweight SOAP client"
HOMEPAGE="https://github.com/suds-community/suds"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz"
S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="LGPL-3"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"

DOCS=( README.md notes/. )

distutils_enable_tests pytest
