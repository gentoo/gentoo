# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_6 python3_7 )

inherit distutils-r1

DESCRIPTION="library for running  multi-thread, multi-process applications"
HOMEPAGE="https://pypi.org/project/oslo.concurrency/"
SRC_URI="mirror://pypi/${PN:0:1}/oslo.concurrency/oslo.concurrency-${PV}.tar.gz"
S="${WORKDIR}/oslo.concurrency-${PV}"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm64 ~x86"
IUSE=""
RESTRICT=""

CDPEND=">=dev-python/pbr-2.0.0[${PYTHON_USEDEP}]
	!~dev-python/pbr-2.1.0[${PYTHON_USEDEP}]"
DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]
	${CDEPEND}"
RDEPEND="
	${CDEPEND}
	>=dev-python/oslo-config-5.2.0[${PYTHON_USEDEP}]
	>=dev-python/oslo-i18n-3.15.3[${PYTHON_USEDEP}]
	>=dev-python/oslo-utils-3.33.0[${PYTHON_USEDEP}]
	>=dev-python/six-1.10.0[${PYTHON_USEDEP}]
	>=dev-python/fasteners-0.7.0[${PYTHON_USEDEP}]
"
