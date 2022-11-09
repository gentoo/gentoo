# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

DESCRIPTION="Canonical JSON"
HOMEPAGE="
	https://github.com/matrix-org/python-canonicaljson/
	https://pypi.org/project/canonicaljson/
"
SRC_URI="
	https://github.com/matrix-org/python-canonicaljson/archive/v${PV}.tar.gz
		-> ${P}.gh.tar.gz
"

S="${WORKDIR}/python-${P}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~ppc64"

RDEPEND="dev-python/simplejson[${PYTHON_USEDEP}]"

distutils_enable_tests unittest
