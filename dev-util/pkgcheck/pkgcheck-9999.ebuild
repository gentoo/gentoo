# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python3_{6..9} )
DISTUTILS_IN_SOURCE_BUILD=1
inherit distutils-r1 eutils

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pkgcore/pkgcheck.git"
	inherit git-r3
else
	KEYWORDS="~amd64 ~arm ~hppa ~ia64 ~ppc ~ppc64 ~s390 ~sparc ~x86"
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
fi

DESCRIPTION="pkgcore-based QA utility for ebuild repos"
HOMEPAGE="https://github.com/pkgcore/pkgcheck"

LICENSE="BSD"
SLOT="0"
IUSE="test"
RESTRICT="!test? ( test )"

if [[ ${PV} == *9999 ]]; then
	RDEPEND="
		~dev-python/snakeoil-9999[${PYTHON_USEDEP}]
		~sys-apps/pkgcore-9999[${PYTHON_USEDEP}]"
else
	RDEPEND="
		>=dev-python/snakeoil-0.8.8[${PYTHON_USEDEP}]
		>=sys-apps/pkgcore-0.10.11[${PYTHON_USEDEP}]"
fi
RDEPEND+="
	dev-python/chardet[${PYTHON_USEDEP}]
	dev-python/lxml[${PYTHON_USEDEP}]
	dev-python/pathspec[${PYTHON_USEDEP}]
"
DEPEND="${RDEPEND}
	dev-python/setuptools[${PYTHON_USEDEP}]
	test? ( dev-python/pytest[${PYTHON_USEDEP}] )
"

python_test() {
	esetup.py test
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
