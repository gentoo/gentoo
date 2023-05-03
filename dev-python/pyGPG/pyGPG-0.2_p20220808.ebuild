# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DISTUTILS_USE_PEP517=setuptools
PYTHON_COMPAT=( python3_{9..11} )

inherit distutils-r1

if [[ ${PV} == *9999 ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/dol-sen/pyGPG.git"
	EGIT_BRANCH="master"
elif [[ ${PV} == *_p* ]] ; then
	MY_COMMIT="eb44ec69978044809325a0a9c8972d1d4f573b47"
	SRC_URI="https://github.com/dol-sen/pyGPG/archive/${MY_COMMIT}.tar.gz -> ${P}.gh.tar.gz"
	S="${WORKDIR}"/${PN}-${MY_COMMIT}
else
	SRC_URI="https://dev.gentoo.org/~dolsen/releases/pyGPG/${P}.tar.gz"
fi

DESCRIPTION="A python interface wrapper for gnupg's gpg command"
HOMEPAGE="https://github.com/dol-sen/pyGPG"

LICENSE="BSD"
SLOT="0"
if [[ ${PV} != *9999 ]] ; then
	KEYWORDS="~alpha amd64 arm arm64 ~hppa ~ia64 ~mips ppc ppc64 ~riscv ~s390 sparc x86"
fi

RDEPEND="app-crypt/gnupg"

EPYTEST_DESELECT=(
	# Expired keys
	test/pyGPG/test_gpg.py::test_listkeys2
	test/pyGPG/test_gpg.py::test_listkey2
	test/pyGPG/test_gpg.py::test_listkey
	test/pyGPG/test_gpg.py::test_fingerprint2
)

distutils_enable_tests pytest

pkg_postinst() {
	elog "This is experimental software."
	elog "The APIs it installs should be considered unstable"
	elog "and are subject to change."
	elog
	elog "Please file any enhancement requests, or bugs"
	elog "at https://github.com/dol-sen/pyGPG/issues"
	elog "I am also on IRC @ #gentoo-ci of the Libera.Chat network"
	elog
	ewarn "There may be some Python 3 compatibility issues still."
	ewarn "Please help debug/fix/report them in github or bugzilla."
}
