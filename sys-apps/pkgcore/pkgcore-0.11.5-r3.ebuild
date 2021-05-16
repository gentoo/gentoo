# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..9} )
DISTUTILS_IN_SOURCE_BUILD=1
inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pkgcore/pkgcore.git"
	inherit git-r3
else
	KEYWORDS="~alpha amd64 arm arm64 hppa ~ia64 ppc ppc64 ~s390 sparc x86 ~x64-macos"
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
fi

DESCRIPTION="a framework for package management"
HOMEPAGE="https://github.com/pkgcore/pkgcore"

LICENSE="BSD MIT"
SLOT="0"

RDEPEND="dev-python/lxml[${PYTHON_USEDEP}]"
if [[ ${PV} == *9999 ]]; then
	RDEPEND+=" ~dev-python/snakeoil-9999[${PYTHON_USEDEP}]"
else
	RDEPEND+="
		<dev-python/snakeoil-0.9.5[${PYTHON_USEDEP}]
		>=dev-python/snakeoil-0.9.3[${PYTHON_USEDEP}]"
fi
BDEPEND="
	test? (
		dev-python/pytest[${PYTHON_USEDEP}]
		dev-vcs/git
	)
"

PATCHES=(
	"${FILESDIR}/pkgcore-0.10.13-metadata-xsd-2.patch"
	"${FILESDIR}/pkgcore-0.10.18-sighdlr.patch"
)

distutils_enable_tests setup.py

src_test() {
	local -x PYTHONDONTWRITEBYTECODE=
	distutils-r1_src_test
}

python_install_all() {
	local DOCS=( NEWS.rst )
	[[ ${PV} == *9999 ]] || doman man/*
	distutils-r1_python_install_all
}
