# Copyright 2019-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_IN_SOURCE_BUILD=1
PYTHON_COMPAT=( python3_{8..11} )

inherit distutils-r1

DESCRIPTION="Python wrapper around the reflink system calls"
HOMEPAGE="https://gitlab.com/rubdos/pyreflink"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~ppc64 ~x86"

RDEPEND="virtual/python-cffi[${PYTHON_USEDEP}]"
DEPEND="${RDEPEND}"
BDEPEND="${RDEPEND}
	test? ( sys-fs/btrfs-progs )
"

distutils_enable_sphinx docs
distutils_enable_tests pytest

python_prepare_all() {
	sed -e 's|'\''pytest-runner'\'',\?||' -i setup.py || die
	distutils-r1_python_prepare_all
}

python_test() {
	local notestmsg="Tests need FEATURES='-usersandbox -userpriv -sandbox'"
	if [[ ${EUID} != 0 ]]; then
		ewarn "${notestmsg}"
	elif
		has sandbox ${FEATURES}; then
			ewarn "${notestmsg}"
	else
		pushd "${BUILD_DIR}"/lib >/dev/null || die
		# module import will fail with any other directory structure
		cp -rv "${S}"/tests ./ || die
		pytest -vv || die "Tests fail with ${EPYTHON}"
		popd >/dev/null || die
	fi
}
