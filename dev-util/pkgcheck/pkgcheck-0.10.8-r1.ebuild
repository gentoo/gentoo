# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

PYTHON_COMPAT=( python3_{8..10} )
DISTUTILS_IN_SOURCE_BUILD=1
inherit distutils-r1 optfeature

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pkgcore/pkgcheck.git"
	inherit git-r3
else
	KEYWORDS="~alpha amd64 arm ~arm64 hppa ~ia64 ppc ~ppc64 ~riscv ~s390 sparc x86 ~x64-macos"
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
fi

DESCRIPTION="pkgcore-based QA utility for ebuild repos"
HOMEPAGE="https://github.com/pkgcore/pkgcheck"

LICENSE="BSD MIT"
SLOT="0"

if [[ ${PV} == *9999 ]]; then
	RDEPEND="
		~dev-python/snakeoil-9999[${PYTHON_USEDEP}]
		~sys-apps/pkgcore-9999[${PYTHON_USEDEP}]"
else
	RDEPEND="
		>=dev-python/snakeoil-0.9.6[${PYTHON_USEDEP}]
		>=sys-apps/pkgcore-0.12.8[${PYTHON_USEDEP}]"
fi
RDEPEND+="
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/lazy-object-proxy[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pathspec[${PYTHON_USEDEP}]
	>=dev-python/tree-sitter-0.19.0[${PYTHON_USEDEP}]
"
BDEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-python/requests[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

distutils_enable_tests setup.py

src_prepare() {
	# extend allowed system uid/gid range per Council 2021-11-14
	sed -i -e 's:500:750:g' \
		src/pkgcheck/checks/acct.py \
		tests/checks/test_acct.py || die
	distutils-r1_src_prepare
}

src_test() {
	local -x PYTHONDONTWRITEBYTECODE=
	distutils-r1_src_test
}

python_install_all() {
	local DOCS=( NEWS.rst )
	[[ ${PV} == *9999 ]] || doman man/*
	distutils-r1_python_install_all
}

pkg_postinst() {
	optfeature "Network check support" dev-python/requests
	optfeature "Perl module version check support" dev-perl/Gentoo-PerlMod-Version
}
