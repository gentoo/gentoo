# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DOCS_BUILDER="mkdocs"
DOCS_DEPEND="dev-python/mkdocs-material"
DOCS_DIR="doc"

PYTHON_COMPAT=( python3_{10..12} )

DISTUTILS_USE_PEP517=setuptools
inherit distutils-r1 docs

if [[ ${PV} == "9999" ]] ; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/eduvpn/python-${PN}.git"
	S="${WORKDIR}/${P}"
else
	SRC_URI="https://github.com/eduvpn/python-eduvpn-client/archive/refs/tags/${PV}.tar.gz -> ${P}.gh.tar.gz"
	S="${WORKDIR}/python-${P}"
fi

DESCRIPTION="Linux client and Python client API for eduVPN"
HOMEPAGE="https://www.eduvpn.org/"

LICENSE="GPL-3+"
SLOT="0"

# Test suite involves adding NetworkManager configuration entries,
# disable for now.
RESTRICT="test"

RDEPEND="
	dev-python/requests[${PYTHON_USEDEP}]
	dev-python/pygobject:3[${PYTHON_USEDEP}]
	>=net-vpn/eduvpn-common-1.1.99.0[${PYTHON_USEDEP}]
"
