# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..10} )

inherit distutils-r1

# 0.1.1 isn't tagged on GitHub
COMMIT_HASH="ee3dcca0df300e0584e129a4ab81828be002684b"
MY_PN="${PN//-/_}"
MY_P="${MY_PN}-${PV}"

DESCRIPTION="Pure python RFC3986 validator"
HOMEPAGE="https://pypi.org/project/rfc3986-validator/ https://github.com/naimetti/rfc3986-validator"
SRC_URI="mirror://pypi/${MY_PN:0:1}/${MY_PN}/${MY_P}.tar.gz"
S=${WORKDIR}/${MY_P}

LICENSE="MIT"
SLOT="0"
KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"

RDEPEND="dev-python/rfc3987[${PYTHON_USEDEP}]"
BDEPEND="test? ( dev-python/hypothesis[${PYTHON_USEDEP}] )"

distutils_enable_tests pytest

python_prepare_all() {
	# remove dep on pytest-runner
	sed -i -r "s:('|\")pytest-runner('|\")(,|)::" setup.py || die
	distutils-r1_python_prepare_all
}
