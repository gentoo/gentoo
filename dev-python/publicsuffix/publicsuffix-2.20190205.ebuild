# Copyright 2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_6 python3_7 )
inherit distutils-r1

DESCRIPTION="Get a public suffix for a domain name using the Public Suffix List."
HOMEPAGE="https://github.com/nexB/python-publicsuffix2"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}2/${PN}2-${PV}.tar.gz"
S="${WORKDIR}/${PN}2-${PV}"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="${DEPEND}
	>=dev-python/requests-2.7.0[${PYTHON_USEDEP}]"
BDEPEND=""
