# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{7,8} )
DISTUTILS_USE_SETUPTOOLS=bdepend

inherit distutils-r1

MY_PN=${PN/-/.}

DESCRIPTION="Oslo Caching around dogpile.cache"
HOMEPAGE="https://launchpad.net/oslo"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_PN}-${PV}.tar.gz -> ${P}.tar.gz"

S="${WORKDIR}/${MY_PN}-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="amd64 ~arm64 x86 ~amd64-linux ~x86-linux"

DEPEND="
	>=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
"
RDEPEND="
	>=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0[${PYTHON_USEDEP}]
	>=dev-python/dogpile-cache-1.0.2[${PYTHON_USEDEP}]
	>=dev-python/oslo-config-8.1.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-5.0.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-log-4.2.1[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-4.2.0[${PYTHON_USEDEP}]
"
