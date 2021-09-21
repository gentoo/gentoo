# Copyright 2020-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

MY_PV=release-2.2019-12-21

DESCRIPTION="Get a public suffix for a domain name using the Public Suffix List."
HOMEPAGE="https://github.com/nexB/python-publicsuffix2"
SRC_URI="
	https://github.com/nexB/python-publicsuffix2/archive/${MY_PV}.tar.gz
		-> ${P}.gh.tar.gz
"
S="${WORKDIR}/python-${PN}2-${MY_PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"

RDEPEND=">=dev-python/requests-2.7.0[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
