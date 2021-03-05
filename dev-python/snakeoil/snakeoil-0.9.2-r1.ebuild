# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{8..9} )
PYTHON_REQ_USE="threads(+)"
inherit distutils-r1

if [[ ${PV} == *9999 ]] ; then
	EGIT_REPO_URI="https://github.com/pkgcore/snakeoil.git"
	inherit git-r3
else
	KEYWORDS="~alpha amd64 ~arm ~arm64 ~hppa ~ia64 ~ppc ppc64 ~s390 sparc x86 ~x64-macos"
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
fi

DESCRIPTION="misc common functionality and useful optimizations"
HOMEPAGE="https://github.com/pkgcore/snakeoil"

LICENSE="BSD BSD-2 MIT"
SLOT="0"

RDEPEND="
	dev-python/lazy-object-proxy[${PYTHON_USEDEP}]"

[[ ${PV} == 9999 ]] && BDEPEND+=" dev-python/cython[${PYTHON_USEDEP}]"

distutils_enable_tests pytest
