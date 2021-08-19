# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
inherit distutils-r1

MY_P=${P/-/.}
DESCRIPTION="NFS-safe file locking with timeouts for POSIX systems"
HOMEPAGE="https://gitlab.com/warsaw/flufl.lock"
SRC_URI="mirror://pypi/${PN::1}/${PN/-/.}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

RDEPEND="
	dev-python/atpublic[${PYTHON_USEDEP}]
	dev-python/psutil[${PYTHON_USEDEP}]"
BDEPEND="
	test? ( dev-python/sybil[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

src_prepare() {
	sed -i -e 's:--cov=flufl --cov-report=term --cov-report=xml::' \
		setup.cfg || die
	distutils-r1_src_prepare
}

python_install_all() {
	distutils-r1_python_install_all
	find "${D}" -name '*.pth' -delete || die
}
