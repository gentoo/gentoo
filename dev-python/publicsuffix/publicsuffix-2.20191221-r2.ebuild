# Copyright 2020-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

PV_DATE=$(ver_cut 2)
MY_PV=release-$(ver_cut 1).${PV_DATE::4}-${PV_DATE:4:2}-${PV_DATE:6:2}
MY_P=python-publicsuffix2-${MY_PV}

DESCRIPTION="Get a public suffix for a domain name using the Public Suffix List"
HOMEPAGE="
	https://github.com/nexB/python-publicsuffix2/
"
SRC_URI="
	https://github.com/nexB/python-publicsuffix2/archive/${MY_PV}.tar.gz
		-> ${MY_P}.gh.tar.gz
"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="amd64 ~arm64 ~x86"

RDEPEND="
	>=dev-python/requests-2.7.0[${PYTHON_USEDEP}]
"

distutils_enable_tests pytest
